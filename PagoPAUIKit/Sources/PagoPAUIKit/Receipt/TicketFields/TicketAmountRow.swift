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
}

#Preview {
    TicketAmountRow(title: "Bonus ID Pay", amount: "59,99 €")
}
