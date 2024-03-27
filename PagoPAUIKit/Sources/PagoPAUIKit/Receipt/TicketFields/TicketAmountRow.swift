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
    var isSuccess: Bool
    
    public init(title: String, amount: String, isSuccess: Bool) {
        self.title = title
        self.amount = amount
        self.isSuccess = isSuccess
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

            if !isSuccess {
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
    VStack(spacing: 20) {
        TicketAmountRow(title: "Bonus ID Pay", amount: "59,99 €", isSuccess: true)
            .frame(width: 213)
            .padding(.horizontal, 16.0)
        
        TicketAmountRow(title: "Bonus ID Pay", amount: "59,99 €", isSuccess: false)
            .frame(width: 213)
            .padding(.horizontal, 16.0)
    }
}
