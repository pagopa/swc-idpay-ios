//
//  TransactionModel+TestExtensions.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 28/02/24.
//

import Foundation

#if DEBUG
extension TransactionModel {
    
    init(status: TransactionStatus,
         date: String,
         goodsCost: Int,
         coveredAmount: Int,
         idPayTransactionId: String,
         milTransactionId: String,
         terminalID: String,
         initiativeID: String,
         secondFactor: String) {
        self.status = status
        self.date   = date.toUTCDate
        self.goodsCost = goodsCost
        self.coveredAmount = coveredAmount
        self.idpayTransactionId = idPayTransactionId
        self.milTransactionId = milTransactionId
        self.terminalID = terminalID
        self.initiativeId = initiativeID
        self.secondFactor = secondFactor
    }
    
    static var fallbackTransaction: TransactionModel {
        TransactionModel(status: .authorized,
                         date: "2023-09-11T12:45:33",
                         goodsCost: 5599,
                         coveredAmount: 5599,
                         idPayTransactionId: "fakeIdPayTransactionid",
                         milTransactionId: "fakeMilTransactionId",
                         terminalID: "g64tg3ryu",
                         initiativeID: "xxxx",
                         secondFactor: "0000907783632457")
    }
    
    static var mockedSuccessTransaction: TransactionModel {
        do {
            return try UITestingHelper.getMockedObject(jsonName: "AuthorizedTransaction")!
        } catch {
            return fallbackTransaction
        }
    }
    
    static var mockedCancelledTransaction: TransactionModel {
        do {
            return try UITestingHelper.getMockedObject(jsonName: "CancelledTransaction")!
        } catch {
            return fallbackTransaction
        }
    }
    
    static var mockedIdentifiedTransaction: TransactionModel {
        do {
            return try UITestingHelper.getMockedObject(jsonName: "IdentifiedTransaction")!
        } catch {
            return fallbackTransaction
        }
    }
    
    static var mockedCreatedTransaction: TransactionModel {
        do {
            return try UITestingHelper.getMockedObject(jsonName: "CreatedTransaction")!
        } catch {
            return fallbackTransaction
        }
    }
    
    static var randomTransactionsList: [TransactionModel] {
        var transactions: [TransactionModel] = []
        (0...Int.random(in: 5...10)).forEach { _ in
            transactions.append(randomTransaction)
        }
        return transactions
    }
    
    static var randomTransaction: TransactionModel {
        let transactionStates: [TransactionStatus] = [.authorized, .cancelled]
        return TransactionModel(status: transactionStates.randomElement()!,
                                date: Date.randomUTCDateString(),
                                goodsCost: Int.random(in: 100...1000),
                                coveredAmount: 135,
                                idPayTransactionId: String.randomString(length: 16),
                                milTransactionId: String.randomString(length: 16),
                                terminalID: "rwkmek1x",
                                initiativeID: String.randomString(length: 16),
                                secondFactor: String.randomString(length: 16))
    }
}
#endif
