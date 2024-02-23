//
//  ReceiptPdfModel.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 12/01/24.
//

import Foundation

class ReceiptPdfModel {
    
    var initiative: Initiative
    var transaction: TransactionModel

    init(initiative: Initiative, transaction: TransactionModel) {
        self.initiative = initiative
        self.transaction = transaction
    }
}
