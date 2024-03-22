//
//  TransactionModel.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 11/01/24.
//

import Foundation
import PagoPAUIKit

struct TransactionModel: Decodable {
    
    var status: TransactionStatus
    var date: Date?
    var goodsCost: Int
    var coveredAmount: Int?
    var idpayTransactionId: String
    var milTransactionId: String
    var terminalID: String
    var initiativeId: String
    var secondFactor: String?
    var residualAmount: Int {
        guard let coveredAmount else { return 0 }
        return goodsCost - coveredAmount
    }
    
    enum CodingKeys: CodingKey {
        case status
        case timestamp
        case goodsCost
        case coveredAmount
        case idpayTransactionId
        case milTransactionId
        case trxCode
        case initiativeId
        case secondFactor
    }
    
    init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<TransactionModel.CodingKeys> = try decoder.container(keyedBy: TransactionModel.CodingKeys.self)
        self.status = try container.decode(TransactionStatus.self, forKey: TransactionModel.CodingKeys.status)
        let timestamp = try container.decode(String.self, forKey: TransactionModel.CodingKeys.timestamp)
        self.date = timestamp.toUTCDate
        self.goodsCost = try container.decode(Int.self, forKey: TransactionModel.CodingKeys.goodsCost)
        self.coveredAmount = try? container.decodeIfPresent(Int.self, forKey: TransactionModel.CodingKeys.coveredAmount)
        self.idpayTransactionId = try container.decode(String.self, forKey: TransactionModel.CodingKeys.idpayTransactionId)
        self.milTransactionId = try container.decode(String.self, forKey: TransactionModel.CodingKeys.milTransactionId)
        self.terminalID = try container.decode(String.self, forKey: TransactionModel.CodingKeys.trxCode)
        self.initiativeId = try container.decode(String.self, forKey: TransactionModel.CodingKeys.initiativeId)
        self.secondFactor = try? container.decode(String.self, forKey: TransactionModel.CodingKeys.secondFactor)
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
