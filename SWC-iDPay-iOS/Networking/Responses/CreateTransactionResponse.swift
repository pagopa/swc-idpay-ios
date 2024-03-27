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
        
    mutating func addValuesFrom(headers: [AnyHashable: Any]) {
        
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
            idpayTransactionId: "fakeIdPayTransactionId",
            milTransactionId: "fakeMilTransactionId",
            initiativeId: "fakeInitiativeId",
            timestamp: Date().toUTCString(),
            goodsCost: 500,
            challenge: String.base64StringFromBinary([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07]),
            trxCode: "A7UG8GHI3",
            qrCode: "Nm2dtfgFFtr9ID9NwZB4QRpvdvd1Pd9a",
            status: "CREATED",
            retryAfter: 1,
            maxRetries: 2)
    }
    
    static var mockedCreatedHighRetries: Self {
        return CreateTransactionResponse(
            idpayTransactionId: "fakeIdPayTransactionId",
            milTransactionId: "fakeMilTransactionId",
            initiativeId: "fakeInitiativeId",
            timestamp: Date().toUTCString(),
            goodsCost: 500,
            challenge: String.base64StringFromBinary([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07]),
            trxCode: "A7UG8GHI3",
            qrCode: "Nm2dtfgFFtr9ID9NwZB4QRpvdvd1Pd9a",
            status: "CREATED",
            retryAfter: 1,
            maxRetries: 10)
    }
    
    static var mockedIdentified: Self {
        return CreateTransactionResponse(
            idpayTransactionId: "fakeIdPayTransactionId",
            milTransactionId: "fakeMilTransactionId",
            initiativeId: "fakeInitiativeId",
            timestamp: Date().toUTCString(),
            goodsCost: 500,
            challenge: String.base64StringFromBinary([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07]),
            trxCode: "A7UG8GHI3",
            status: "IDENTIFIED")
    }
}
