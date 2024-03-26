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
        let icon: Image.PAIcon?
        
        switch transaction.status {
        case .authorized:
            icon = .checkmark
        case .cancelled:
            icon = .cancelled
        default:
            icon = nil
        }
        
        self.init(
            iconLeft: icon,
            titleText: transaction.initiativeId,
            subTitleText: transaction.date?.formattedDateTime?.uppercased() ?? String.emptyDataPlaceholder,
            amountText: transaction.coveredAmount?.formattedCurrency)
    }
}
