//
//  TransactionStatus.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 12/01/24.
//

import Foundation

enum TransactionStatus: String, Codable {
    case created    = "CREATED"
    case identified = "IDENTIFIED"
    case authorized = "AUTHORIZED"
    case rejected   = "REJECTED"
    case rewarded   = "REWARDED"
    case cancelled  = "CANCELLED"
    
    var description: String {
        switch self {
        case .authorized, .rewarded:
            return "ESEGUITA"
        case .cancelled:
            return "ANNULLATA"
        default:
            return "-"
        }
    }
    
    var ticketDescription: String {
        switch self {
        case .authorized, .rewarded:
            return "RICEVUTA DI PAGAMENTO"
        case .cancelled:
            return "RICEVUTA DI ANNULLAMENTO"
        default:
            return "RICEVUTA"
        }
    }
    
    var isSuccess: Bool {
        return (self == .authorized || self == .rewarded)
    }
}
