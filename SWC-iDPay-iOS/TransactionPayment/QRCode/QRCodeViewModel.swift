//
//  QRCodeViewModel.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 22/03/24.
//

import Foundation

class QRCodeViewModel: TransactionDeleteVM {
    
    var transactionData: CreateTransactionResponse
    
    init(networkClient: Requestable, transactionData: CreateTransactionResponse, initiative: Initiative? = nil) {
        self.transactionData = transactionData
        
        super.init(networkClient: networkClient, transactionID: self.transactionData.milTransactionId, goodsCost: self.transactionData.goodsCost, initiative: initiative)
    }
    
}
