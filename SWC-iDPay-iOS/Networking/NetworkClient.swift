//
//  NetworkClient.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 12/02/24.
//

import Foundation

class NetworkClient: Requestable {
    
    private let baseURL: URL
    private let session: URLSession
    let sessionManager: SessionManager
    
    private lazy var jsonDecoder: JSONDecoder = {
        var decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    private var defaultSession: URLSession = {
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 30.0
        sessionConfig.timeoutIntervalForResource = 60.0
        let session = URLSession(configuration: sessionConfig)
        return session
    }()
    
    init(environment: APIEnvironment, sessionManager: SessionManager = SessionManager(), session: URLSession? = nil) {
        self.baseURL = URL(string: environment.baseURLString)!
        self.sessionManager = sessionManager
        self.session = session ?? defaultSession
    }
    
    func login(username: String, password: String) async throws {
        let response: LoginResponse = try await sendRequest(for: .login(username: username, password: password))
        try sessionManager.saveSessionData(response)
    }
    
    func getInitiatives() async throws -> [Initiative] {
        let response: InitiativesResponse = try await sendRequest(for: .initiatives)
        return response.initiatives
    }
    
    func createTransaction(initiativeId: String, amount: Int) async throws -> CreateTransactionResponse{
        let response: CreateTransactionResponse = try await sendRequest(for: .createTransaction(initiativeId: initiativeId, amount: amount))
        return response
    }
    
    func verifyCIE(milTransactionId: String, nis: String, ciePublicKey: String, signature: String, sod: String) async throws -> VerifyCIEResponse {
        let response: VerifyCIEResponse = try await sendRequest(for: .verifyCIE(milTransactionId: milTransactionId, nis: nis, ciePublicKey: ciePublicKey, signature: signature, sod: sod))
        return response
    }
    
    func verifyTransactionStatus(milTransactionId: String) async throws -> TransactionModel {
        let transaction: TransactionModel = try await sendRequest(for: .transactionDetail(milTransactionId))
        return transaction
    }
    
    func authorizeTransaction(milTransactionId: String, authCodeBlockData: AuthCodeData) async throws {
        let _: EmptyResponse = try await sendRequest(for: .authorize(milTransactionId: milTransactionId, kid: authCodeBlockData.kid, encSessionKey: authCodeBlockData.encSessionKey, authCodeBlock: authCodeBlockData.authCodeBlock))
        return
    }
    
    func deleteTransaction(milTransactionId: String) async throws -> Bool {
        let _: EmptyResponse = try await sendRequest(for: .deleteTransaction(milTransactionId))
        return true
    }
    
    func transactionHistory() async throws -> [TransactionModel] {
        let transactionHistory: TransactionHistoryResponse = try await sendRequest(for: .transactionHistory)
        return transactionHistory.transactions
    }

    func refreshToken() async throws {
        guard let refreshToken = try sessionManager.getRefreshToken() else {
            throw HTTPResponseError.unauthorized
        }
        
        let response: LoginResponse = try await sendRequest(
            for: .refreshToken(refreshToken),
            headers: ["Authorization": "Bearer \(sessionManager.getAccessToken())"]
        )
        try sessionManager.saveSessionData(response)
    }

}

extension NetworkClient {
        
    private func sendRequest<T:Decodable>(for endpoint: Endpoint, params: Parameters? = nil, headers: Headers? = nil) async throws -> T {
        
        var apiRequest: URLRequest = URLRequest.buildRequest(baseUrl: baseURL, endpoint: endpoint)
        
        if let headers = headers {
            apiRequest.addHeaders(headers)
        }
        
        switch endpoint {
        case .login, .refreshToken:
            break
        default:
            do {
                var accessToken = try sessionManager.getAccessToken()
                
                if sessionManager.isTokenExpired() {
                    // REFRESH TOKEN
                    try await refreshToken()
                    accessToken = try sessionManager.getAccessToken()
                    apiRequest.addHeaders(["Authorization": "Bearer \(accessToken)"])
                }
            } catch {
                NotificationCenter.default.post(name: .sessionExpired, object: nil)
                throw error
            }
        }
        
        print("----------------------------------------INPUT----------------------------------------------------------")
        print("URL: \(String(describing: apiRequest.url))")
        print("METHOD: \(String(describing: apiRequest.httpMethod))")
        print("HEADERS: \(String(describing: apiRequest.allHTTPHeaderFields))")
        if let body = apiRequest.httpBody {
            print("BODY:")
            print(NSString(data: body, encoding: String.Encoding.utf8.rawValue)!)
        }
        else {
            print("BODY: -")
        }
        print("----------------------------------------INPUT----------------------------------------------------------")
        
        let (data, response) = try await session.data(for: apiRequest)
        
        if let httpResponse = response as? HTTPURLResponse {
            print("----------------------------------------OUTPUT----------------------------------------------------------")
            print("URL: \(String(describing: httpResponse.url))")
            print("HEADERS: \(String(describing: httpResponse.allHeaderFields))")
            print("STATUS CODE: \(String(describing: httpResponse.statusCode))")
            print("BODY:")
            print(NSString(data: data, encoding: String.Encoding.utf8.rawValue)!)
            print("----------------------------------------OUTPUT----------------------------------------------------------")
            
            guard 200...299 ~= httpResponse.statusCode else {
                throw HTTPResponseError.decodeError(status: httpResponse.statusCode, data: data)
            }
            
            switch endpoint {
            case .createTransaction:
                var transactionResponse = try self.jsonDecoder.decode(T.self, from: data)
                if var response = transactionResponse as? CreateTransactionResponse {
                    response.addValuesFrom(headers: httpResponse.allHeaderFields)
                    transactionResponse = (response as! T)
                }
                return transactionResponse
            default:
                // Return data
                if data.isEmpty {
                    guard let emptyJson = "{}".data(using: .utf8) else {
                        throw HTTPResponseError.genericError
                    }
                    return try self.jsonDecoder.decode(T.self, from: emptyJson)
                } else {
                    return try self.jsonDecoder.decode(T.self, from: data)
                }
            }
        } else {
            throw HTTPResponseError.genericError
        }
    }
}
