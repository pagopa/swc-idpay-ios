//
//  TransactionHistoryDetailViewModel.swift
//  SWC-iDPay-iOS
//
//  Created by Pier Domenico Bonamassa on 22/02/24.
//

import Foundation
import Combine

@MainActor
class TransactionHistoryDetailViewModel: TransactionDeleteVM {

    @Published var transaction: TransactionModel  
    @Published var showResultPage: Bool = false
    @Published var showReceiptDialog: Bool = false
    @Published var receiptPdfModel: ReceiptPdfModel
    
    private var cancellables = Set<AnyCancellable>()
    
    init(transaction: TransactionModel, networkClient: Requestable) {
        self.transaction = transaction
        self.receiptPdfModel = ReceiptPdfModel(transaction: transaction)
        super.init(networkClient: networkClient, transactionID: transaction.milTransactionId, goodsCost: transaction.goodsCost)

    }

    
}

