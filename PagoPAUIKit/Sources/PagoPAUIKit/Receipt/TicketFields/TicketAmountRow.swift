//
//  TicketAmountRow.swift
//
//
//  Created by Stefania Castiglioni on 10/01/24.
//

import SwiftUI

public struct TicketAmountRow: View {
    var title: String
    var amount: String
    var transactionStatus: OperationStatus
    
    public init(title: String, amount: String, transactionStatus: OperationStatus) {
        self.title = title
        self.amount = amount
        self.transactionStatus = transactionStatus
    }
    
    public var body: some View {
        VStack(spacing: 13) {
            Divider()
            
            HStack {
                Text(title)
                Spacer()
                Text(amount)
            }
            .font(.PAFont.receiptAmountLabelB)
            .frame(maxWidth: .infinity)

            if transactionStatus == .refunded {
                Text("Il pagamento è stato annullato e riaccreditato sul tuo portafoglio ID Pay.")
                    .font(.PAFont.receiptTitle2)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Divider()
        }
        .frame(minHeight: 60.0)
        .fixedSize(horizontal: false, vertical: true)
    }
}

#Preview {
    TicketAmountRow(title: "Bonus ID Pay", amount: "59,99 €", transactionStatus: .refunded)
        .frame(width: 213)
        .padding(.horizontal, 16.0)
}
