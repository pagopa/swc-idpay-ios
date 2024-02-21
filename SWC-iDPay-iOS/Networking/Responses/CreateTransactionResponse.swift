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

extension CreateTransactionResponse {

    static var mockedCreated: Self {
        return CreateTransactionResponse(
            idpayTransactionId: "613691ec-15d5-456e-a41c-e469fa4dd060_QRCODE_1694181289491",
            milTransactionId: "ccadc1c4-3913-431e-a569-6cf2ce60946c",
            initiativeId: "649c50b5a03f655e6543af06",
            timestamp: "2023-09-11T12:45:33",
            goodsCost: 50054,
            challenge: "NzI3NzZCNkQ2NTZCMzE3OA==",
            trxCode: "rwkmek1x",
            status: "CREATED")
    }
    
    static var mockedIdentified: Self {
        return CreateTransactionResponse(
            idpayTransactionId: "613691ec-15d5-456e-a41c-e469fa4dd060_QRCODE_1694181289491",
            milTransactionId: "ccadc1c4-3913-431e-a569-6cf2ce60946c",
            initiativeId: "649c50b5a03f655e6543af06",
            timestamp: "2023-09-11T12:45:33",
            goodsCost: 50054,
            challenge: "NzI3NzZCNkQ2NTZCMzE3OA==",
            trxCode: "rwkmek1x",
            status: "IDENTIFIED")
    }
}
