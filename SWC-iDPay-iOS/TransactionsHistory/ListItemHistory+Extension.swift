//
//  ListItemHistory+Extension.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 26/02/24.
//

import PagoPAUIKit
import SwiftUI

extension ListItemHistory {

    init(transaction: TransactionModel) {
       let icon = (transaction.status == .authorized) ? Image.PAIcon.checkmark : Image.PAIcon.cancelled
        self.init(iconLeft: icon, titleText: transaction.initiativeId, subTitleText: transaction.date, amountText: transaction.coveredAmount?.formattedCurrency)
    }
}
