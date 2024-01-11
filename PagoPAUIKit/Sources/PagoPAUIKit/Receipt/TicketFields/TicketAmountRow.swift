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
    
    public init(title: String, amount: String) {
        self.title = title
        self.amount = amount
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

            Divider()
        }
        .font(.PAFont.receiptAmountLabelB)
        .frame(maxWidth: .infinity)
        .frame(minHeight: 60.0)
    }
}

#Preview {
    TicketAmountRow(title: "Bonus ID Pay", amount: "59,99 €")
        .frame(width: 213)
        .padding(.horizontal, 16.0)
}
