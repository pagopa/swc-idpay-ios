//
//  Environment.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 12/02/24.
//

import Foundation

enum APIEnvironment {
    case staging
    case production
    
    var baseURLString: String {
        switch self {
        case .staging:
            return "https://mil-d-apim.azure-api.net"
        case .production:
            return "https://mil-d-apim.azure-api.net"
        }
    }
}
