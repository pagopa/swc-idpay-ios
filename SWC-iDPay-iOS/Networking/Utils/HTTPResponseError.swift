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
        
        if let responseError = try? JSONDecoder().decode(APIResponseError.self, from: data) {
            // RETURN HTTPResponseError based on errors array in response
            return HTTPResponseError.networkError("Service error retrieved: \(responseError.errors?.joined(separator: ", ") ?? "")")
        } else {
            switch status {
            case 401:
                return .unauthorized
            default:
                return HTTPResponseError.genericError
            }
        }
    }
}

struct APIResponseError: Decodable {
    var statusCode: Int
    var errors: [String]?
    var descriptions: [String]?
}
