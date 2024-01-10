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
                    .padding(.bottom, 18.0)
                Text(paymentProvider.name)
                    .font(.PAFont.receiptLabelB)
                    .foregroundColor(.paBlack)
                Text(paymentProvider.address)
                    .font(.PAFont.receiptTitle2)
                    .foregroundColor(.grey650)
            }
            .padding(.bottom, 30.0)
            
            VStack {
                Text("ID Transazione:")
                Text(transactionID)
                    .padding(.bottom, 8.0)
                
                HStack {
                    Text("Terminale:")
                    Text(terminalID)
                }
            }
            .font(.PAFont.receiptMetadata)
        }
        .foregroundColor(.paBlack)
        .frame(maxWidth: .infinity)
        .padding(.top, 20.0)
        .padding(.bottom, 40.0)
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
