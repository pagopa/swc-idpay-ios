//
//  TicketField.swift
//
//
//  Created by Stefania Castiglioni on 10/01/24.
//

import SwiftUI

public struct TicketField: View {
    var title: String
    var value: String
    
    public init(title: String, value: String) {
        self.title = title
        self.value = value
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.PAFont.receiptTitle2)
            Text(value)
                .font(.PAFont.receiptLabelB)
        }
        .foregroundColor(.paBlack)
    }
}

#Preview {
    TicketField(title: "Data e ora", value: "15 Marzo 2023, 16:44")
}
