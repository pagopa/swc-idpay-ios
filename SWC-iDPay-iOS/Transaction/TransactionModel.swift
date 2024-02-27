//
//  TransactionModel.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 11/01/24.
//

import Foundation
import PagoPAUIKit

struct TransactionModel: Codable {
    
    var status: TransactionStatus
    var date: Date?
    var goodsCost: Int
    var coveredAmount: Int?
    var transactionID: String
    var terminalID: String
    var initiativeId: String
    var secondFactor: String?
    
    enum CodingKeys: CodingKey {
        case status
        case timestamp
        case goodsCost
        case coveredAmount
        case milTransactionId
        case trxCode
        case initiativeId
        case secondFactor
    }
   
    fileprivate init(status: TransactionStatus, date: String, goodsCost: Int, coveredAmount: Int, transactionID: String, terminalID: String, initiativeID: String, secondFactor: String) {
        self.status = status
        self.date   = date.toUTCDate
        self.goodsCost = goodsCost
        self.coveredAmount = coveredAmount
        self.transactionID = transactionID
        self.terminalID = terminalID
        self.initiativeId = initiativeID
        self.secondFactor = secondFactor
    }
    
    init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<TransactionModel.CodingKeys> = try decoder.container(keyedBy: TransactionModel.CodingKeys.self)
        self.status = try container.decode(TransactionStatus.self, forKey: TransactionModel.CodingKeys.status)
        let timestamp = try container.decode(String.self, forKey: TransactionModel.CodingKeys.timestamp)
        self.date = timestamp.toUTCDate
        self.goodsCost = try container.decode(Int.self, forKey: TransactionModel.CodingKeys.goodsCost)
        self.coveredAmount = try? container.decodeIfPresent(Int.self, forKey: TransactionModel.CodingKeys.coveredAmount)
        self.transactionID = try container.decode(String.self, forKey: TransactionModel.CodingKeys.milTransactionId)
        self.terminalID = try container.decode(String.self, forKey: TransactionModel.CodingKeys.trxCode)
        self.initiativeId = try container.decode(String.self, forKey: TransactionModel.CodingKeys.initiativeId)
        self.secondFactor = try? container.decode(String.self, forKey: TransactionModel.CodingKeys.secondFactor)
    }
    
    func encode(to encoder: Encoder) throws {
        var container: KeyedEncodingContainer<TransactionModel.CodingKeys> = encoder.container(keyedBy: TransactionModel.CodingKeys.self)
        try container.encode(self.status, forKey: TransactionModel.CodingKeys.status)
        try container.encode(self.date, forKey: TransactionModel.CodingKeys.timestamp) // TODO: Formattare con formato data server
        try container.encode(self.goodsCost, forKey: TransactionModel.CodingKeys.goodsCost)
        try container.encode(self.coveredAmount, forKey: TransactionModel.CodingKeys.coveredAmount)
        try container.encode(self.transactionID, forKey: TransactionModel.CodingKeys.milTransactionId)
        try container.encode(self.terminalID, forKey: TransactionModel.CodingKeys.trxCode)
        try container.encode(self.initiativeId, forKey: TransactionModel.CodingKeys.initiativeId)
        try container.encode(self.secondFactor, forKey: TransactionModel.CodingKeys.secondFactor)
    }
    
    func isCancellable() -> Bool {
        guard status == .authorized, let date = date else { return false }
        let components = Calendar.current.dateComponents([.day], from: date, to: Date())
        if let day = components.day {
            return day < 3
        }
        
        return false
    }

}

extension TransactionModel {
    
    static var fallbackTransaction: TransactionModel {
        TransactionModel(status: .authorized, date: "15 Marzo 2023, 16:44", goodsCost: 5599, coveredAmount: 5599, transactionID: "517a-4216-840E-461f-B011-036A-0fd1-34E1", terminalID: "g64tg3ryu", initiativeID: "xxxx", secondFactor: "0000907783632457")
    }
    
    static var mockedSuccessTransaction: TransactionModel {
        JSONDecoder().decodeFromLocalJSON(name: "AuthorizedTransaction") ?? TransactionModel.fallbackTransaction
    }
    
    static var mockedCancelledTransaction: TransactionModel {
        JSONDecoder().decodeFromLocalJSON(name: "CancelledTransaction") ?? TransactionModel.fallbackTransaction
    }

}
