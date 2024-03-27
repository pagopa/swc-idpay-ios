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
    case sessionExpired
    case maxRetriesExceeded
    case coveredAmountInconsistent
    case invalidCode
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
    
    static func decodeError(status: Int, data: Data) -> HTTPResponseError {
        
        switch status {
        case 400:
            if let errorResponse: BaseHTTPResponse = try? JSONDecoder().decode(BaseHTTPResponse.self, from: data), let errors = errorResponse.errors, errors.count > 0 {
                if errors.contains("00A000053") {
                    return HTTPResponseError.invalidCode
                }
            }
            return .unauthorized
        case 401:
            return .unauthorized
        default:
            return HTTPResponseError.genericError
        }
    }
}
