//
//  TransactionModel.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 11/01/24.
//

import Foundation
import PagoPAUIKit

struct TransactionModel {
    var status: OperationStatus
    var date: String
    var description: String
    var amount: Int
    var bonusAmount: Int
    var transactionID: String
    var terminalID: String
}


