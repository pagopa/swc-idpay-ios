//
//  CIEAuthError.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 15/02/24.
//

import Foundation

enum CIEAuthErrorType {
    case warning
    case error
    case info
}

enum CIEAuthError: Error {
    case expired
    case stolen
    case generic
    case invalidData
    case walletVerifyError
    
    var type: CIEAuthErrorType {
        switch self {
        case .generic:
            return .error
        case .walletVerifyError:
            return .info
        default:
            return .warning
        }
    }
}
