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
    private var sessionManager: SessionManager = SessionManager()
    
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
    
    
    init(environment: APIEnvironment, session: URLSession? = nil) {
        self.baseURL = URL(string: environment.baseURLString)!
        self.session = session ?? defaultSession
    }
    
    func login(username: String, password: String) async throws {
        let response: LoginResponse = try await sendRequest(for: .login, params: ["username": username, "password": password])
        try sessionManager.saveSessionData(response, username: username)
        
    }
    
    func refreshToken() async throws {
        guard let refreshToken = try sessionManager.getRefreshToken(), let username = sessionManager.getUsername() else {
            throw HTTPResponseError.unauthorized
        }
        let response: LoginResponse = try await sendRequest(for: .refreshToken, params: ["refresh_token": refreshToken])
        try sessionManager.saveSessionData(response, username: username)
    }
    
    func getInitiatives() async throws -> [Initiative] {
        let response: InitiativesResponse = try await sendRequest(for: .initiatives)
        return response.initiatives
        
    }
    
}

extension NetworkClient {
    
    private func sendRequest<T:Decodable>(for endpoint: Endpoint, params: Parameters? = nil) async throws -> T {
        
        var apiRequest: URLRequest = URLRequest.buildRequest(baseUrl: baseURL, endpoint: endpoint, parameters: params)
        
        switch endpoint {
        case .login:
            break
        default:
            if let accessToken = try sessionManager.getAccessToken() {
                apiRequest.addHeaders(["Authorization": "Bearer \(accessToken)"])
            } else {
                // REFRESH TOKEN
                try await refreshToken()
                if let accessToken = try sessionManager.getAccessToken() {
                    apiRequest.addHeaders(["Authorization": "Bearer \(accessToken)"])
                } else {
                    throw HTTPResponseError.unauthorized
                }
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
            
            // Return data
            return try self.jsonDecoder.decode(T.self, from: data)
        } else {
            throw HTTPResponseError.genericError
        }
    }
}
