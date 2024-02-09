//
//  HTTPResponseError.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 09/02/24.
//

import Foundation

enum HTTPResponseError: Error {
    
    case internalServiceError
    case invalidEndpoint
    case notFound
    case invalidResponse
    case noData
    case decodeError
    case unauthorized
    case networkError(String)
    case genericError
    
    var reason: String {
        switch self {
        case .notFound:
            return "Not found"
        case .noData:
            return "No data"
        case .internalServiceError:
            return "Internal Server Error"
        case .networkError(let message):
            return message
        default:
            return "Generic error"
        }
    }
}
