//
//  ResidualAmountOutroViewModel.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 21/03/24.
//

import Foundation

class ResidualAmountOutroViewModel: BaseVM {
    
    var transaction: TransactionModel
    
    init(networkClient: Requestable, transaction: TransactionModel) {
        self.transaction = transaction
        super.init(networkClient: networkClient)
    }
}
