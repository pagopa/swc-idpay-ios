//
//  Environment.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 12/02/24.
//

import Foundation

enum APIEnvironment {
    case development
    case staging
    case production
    
    var baseURLString: String {
        switch self {
        case .development:
            return "https://mil-d-apim.azure-api.net"
        case .staging:
            return "https://mil-u-apim.azure-api.net"
        case .production:
            return "https://mil-d-apim.azure-api.net"
        }
    }
}
