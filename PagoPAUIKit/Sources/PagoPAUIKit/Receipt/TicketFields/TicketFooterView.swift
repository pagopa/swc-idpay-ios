//
//  TicketFooterView.swift
//
//
//  Created by Stefania Castiglioni on 10/01/24.
//

import SwiftUI

public struct TicketFooterView: View {
    var paymentProvider: PaymentProviderModel
    var transactionID: String
    var terminalID: String
    
    public init(paymentProvider: PaymentProviderModel, transactionID: String, terminalID: String) {
        self.paymentProvider = paymentProvider
        self.transactionID = transactionID
        self.terminalID = terminalID
    }
    
    public var body: some View {
        VStack {
            VStack {
                Text("Ricevuta trasmessa da")
                    .font(.PAFont.receiptTitle2)
                    .foregroundColor(.paBlack)
                    .padding(.bottom, 8.0)
                Text(paymentProvider.name)
                    .font(.PAFont.receiptLabelB)
                    .foregroundColor(.paBlack)
                Text(paymentProvider.address)
                    .font(.PAFont.receiptTitle2)
                    .foregroundColor(.grey650)
            }
            .padding(.bottom, 20.0)
            
            VStack(spacing: 0.0) {
                Group {
                    Text("ID Transazione:")
                    Text(transactionID)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                HStack {
                    Text("Terminale:")
                    Text(terminalID)
                }
                .padding(.top, 8.0)
            }
            .font(.PAFont.receiptMetadata)
        }
        .foregroundColor(.paBlack)
        .frame(maxWidth: .infinity)
        .padding(.bottom, 30.0)
    }
}

public struct PaymentProviderModel {
    var name: String
    var address: String
    
    public init(name: String, address: String) {
        self.name = name
        self.address = address
    }
}

#Preview {
    TicketFooterView(
        paymentProvider:
            PaymentProviderModel(
                name: "PagoPA S.p.A.",
                address: "Piazza Colonna, 370 · 00187, Roma"),
        transactionID: "517a-4216-840E-461f-B011-036A-0fd1-34E1",
        terminalID: "g64tg3ryu"
    )
}
