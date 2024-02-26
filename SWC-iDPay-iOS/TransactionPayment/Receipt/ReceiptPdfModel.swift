//
//  ReceiptPdfModel.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 12/01/24.
//

import Foundation

class ReceiptPdfModel {
    
    var transaction: TransactionModel
    var initiative: Initiative?

    init(transaction: TransactionModel, initiative: Initiative? = nil) {
        self.transaction = transaction
        self.initiative = initiative
    }
}
