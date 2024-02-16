//
//  TransactionDetailViewModel.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 15/02/24.
//

import Foundation

class TransactionDetailViewModel: BaseVM {
    var transaction: TransactionModel
    var initiative: Initiative
    var verifyCIEResponse: VerifyCIEResponse

    init(networkClient: Requestable, transaction: TransactionModel, initiative: Initiative, verifyCIEResponse: VerifyCIEResponse) {
        self.transaction = transaction
        self.initiative = initiative
        self.verifyCIEResponse = verifyCIEResponse
        super.init(networkClient: networkClient)
    }

    @discardableResult func deleteTransaction() async throws -> Bool {
        return try await networkClient.deleteTransaction(milTransactionId: transaction.transactionID)
    }
}
