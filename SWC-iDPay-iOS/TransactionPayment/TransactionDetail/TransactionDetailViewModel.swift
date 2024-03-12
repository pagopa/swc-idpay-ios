//
//  TransactionDetailViewModel.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 15/02/24.
//

import Foundation
import Combine

enum TransactionDetailState {
    case noMessage
    case confirmDelete
    case confirmDeleteHistory
    case genericError
}

@MainActor
class TransactionDetailViewModel: TransactionDeleteVM {

    var transaction: TransactionModel
    var verifyCIEResponse: VerifyCIEResponse

    init(networkClient: Requestable, transaction: TransactionModel, verifyCIEResponse: VerifyCIEResponse, initiative: Initiative? = nil) {
        self.transaction = transaction
        self.verifyCIEResponse = verifyCIEResponse
            
        super.init(networkClient: networkClient, transactionID: self.transaction.milTransactionId, goodsCost: self.transaction.goodsCost, initiative: initiative)
        
    }
    
}
