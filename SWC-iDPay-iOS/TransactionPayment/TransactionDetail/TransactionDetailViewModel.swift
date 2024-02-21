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
    case genericError
    case transactionDeleted
}

@MainActor
class TransactionDetailViewModel: TransactionDeleteVM {

    var transaction: TransactionModel
    var verifyCIEResponse: VerifyCIEResponse

    init(networkClient: Requestable, transaction: TransactionModel, initiative: Initiative, verifyCIEResponse: VerifyCIEResponse) {
        self.transaction = transaction
        self.verifyCIEResponse = verifyCIEResponse
            
        super.init(networkClient: networkClient, initiative: initiative, transactionID: self.transaction.transactionID, goodsCost: self.transaction.goodsCost)
        
    }
    
}
