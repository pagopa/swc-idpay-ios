//
//  Endpoint.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 09/02/24.
//

import Foundation

typealias HTTPHeaders = [String:String]

enum Endpoint {
    case login(username: String, password: String)
    case refreshToken(_ refreshToken: String)
    case initiatives
    case transactions
    case transactionDetail(_ id: String)
    case createTransaction(initiativeId: String, amount: Int)
    case deleteTransaction(_ id: String)
    case transactionHistory
    case verifyCIE(milTransactionId: String, nis: String, ciePublicKey: String, signature: String, sod: String)
    case authorize(transactionId: String)
    
    var path: String {
        switch self {
        case .login, .refreshToken:
            return "/mil-auth/token"
        case .initiatives:
            return "/mil-idpay/initiatives"
        case .transactions:
            return "/mil-idpay/transactions"
        case .transactionDetail(let id):
            return "/mil-idpay/transactions/\(id)"
        case .createTransaction:
            return "/mil-idpay/transactions"
        case .deleteTransaction(let id):
            return "/mil-idpay/transactions/\(id)"
        case .transactionHistory:
            return "/mil-idpay/transactions"
        case .verifyCIE(let milTransactionId, _, _, _, _):
            return "/mil-idpay/transactions/\(milTransactionId)/verifyCie"
        case .authorize(let transactionId):
            return "/mil-idpay/transactions/\(transactionId)/authorize"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .login, .refreshToken, .createTransaction, .verifyCIE, .authorize:
            return .post
        case .initiatives, .transactions, .transactionDetail(_), .transactionHistory:
            return .get
        case .deleteTransaction(_):
            return .delete
        }
    }
    
    var encoding: ParametersEncoding {
        switch self {
        case .login, .refreshToken:
            return .formUrlEncoded
        default:
            return .jsonEncoding
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .authorize(let milTransactionId), .verifyCIE(let milTransactionId, _, _, _, _):
            return defaultHeaders.merging([
                "Content-Type": "application/json",
                "milTransactionId": milTransactionId
            ], uniquingKeysWith: +)
        case .login, .refreshToken:
            return defaultHeaders.merging([
                "Content-Type": "application/x-www-form-urlencoded",
            ], uniquingKeysWith: +)
        default:
            return defaultHeaders.merging([
                "Content-Type": "application/json"
            ], uniquingKeysWith: +)
        }
    }
    
    var body: Parameters {
        switch self {
        case .login(let username, let password):
            return [
                "scope" : "offline_access",
                "client_id": "5254f087-1214-45cd-94ae-fda53c835197",
                "grant_type" : "password",
                "username": username,
                "password": password
            ]
        case .refreshToken(let refreshToken):
            return [
                "refresh_token": refreshToken,
                "client_id": "5254f087-1214-45cd-94ae-fda53c835197",
                "grant_type" : "refresh_token"
            ]
        case .createTransaction(let initiativeId, let amount):
            return [
                "initiativeId": initiativeId,
                "timestamp": Date().toUTCString(),
                "goodsCost": amount
            ]
        case .verifyCIE(_, let nis, let ciePublicKey, let signature, let sod):
            return [
                "nis": nis,
                "ciePublicKey": ciePublicKey,
                "signature": signature,
                "sod": sod
            ]
        default:
            return [:]
        }
    }

    private var defaultHeaders: HTTPHeaders {
        return [
            "RequestId": String("\(UUID())"),
            "AcquirerId": "4585625",
            "Channel": "POS",
            "TerminalId": "30390022",
            "MerchantId": "12346789"
        ]
    }
}
