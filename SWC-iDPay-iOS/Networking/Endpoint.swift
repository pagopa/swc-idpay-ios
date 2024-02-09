//
//  Endpoint.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 09/02/24.
//

import Foundation

typealias HTTPHeaders = [String:String]

enum Endpoint {
    case login
    case initiatives
    case transactions
    case transactionDetail(_ id: String)
    case createTransaction
    case deleteTransaction(_ id: String)
    case verifyCIE(transactionId: String)
    case authorize(transactionId: String)
    
    var path: String {
        switch self {
        case .login:
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
        case .verifyCIE(let transactionId):
            return "/mil-idpay/transactions/\(transactionId)/verifyCIE"
        case .authorize(let transactionId):
            return "/mil-idpay/transactions/\(transactionId)/authorize"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .login, .createTransaction, .verifyCIE(_), .authorize(_):
            return .post
        case .initiatives, .transactions, .transactionDetail(_):
            return .get
        case .deleteTransaction(_):
            return .delete
        }
    }
    
    var encoding: ParametersEncoding {
        switch self {
        case .login:
            return .formUrlEncoded
        default:
            return .jsonEncoding
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .authorize(let transactionId):
            return defaultHeaders.merging([
                "milTransactionId": transactionId
            ], uniquingKeysWith: +)
        default:
            return defaultHeaders
        }
    }

    private var defaultHeaders: HTTPHeaders {
        return [
            "RequestId": String("\(UUID())")
        ]
    }
}
