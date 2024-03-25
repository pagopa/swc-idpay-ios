//
//  ResidualAmountViewModel.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 21/03/24.
//

import Foundation
import Combine

@MainActor
class ResidualAmountViewModel: TransactionDeleteVM {

    var transaction: TransactionModel
    var residualAmount: Int {
        guard let coveredAmount = transaction.coveredAmount else {
            return 0
        }
        return transaction.goodsCost - coveredAmount
    }

    init(networkClient: Requestable, transaction: TransactionModel, initiative: Initiative? = nil) {
        self.transaction = transaction
        super.init(
            networkClient: networkClient,
            transactionID: self.transaction.milTransactionId,
            goodsCost: self.transaction.goodsCost,
            initiative: initiative)
    }
    
    func setCancelledStatus() {
        transaction.status = .cancelled
    }

}

