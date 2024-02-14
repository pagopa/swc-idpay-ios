//
//  CreateTransactionResponse.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 13/02/24.
//

import Foundation

struct CreateTransactionResponse: Decodable {
    
    var idpayTransactionId: String
    var milTransactionId: String
    var initiativeId: String
    var timestamp: String
    var goodsCost: Int
    var challenge: String
    var trxCode: String
    var qrCode: String?
    var status: String
    var transactionStatusPollingURL: String?
    var retryAfter: Int?
    var maxRetries: Int?
        
    mutating func addValuesFrom(headers: [AnyHashable: Any]){
        
        if let location = headers["Location"] as? String {
            self.transactionStatusPollingURL = location
        }
        
        if let retryAfter = headers["retry-after"] as? String {
            self.retryAfter = Int(retryAfter)
        }
        
        if let maxRetries = headers["max-retries"] as? String {
            self.maxRetries = Int(maxRetries)
        }
    }
}
