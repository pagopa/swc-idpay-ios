//
//  ReceiptTicketView.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 10/01/24.
//

import SwiftUI
import PagoPAUIKit

struct ReceiptTicketView: View {
    private var transaction: TransactionModel

    init(transaction: TransactionModel) {
        self.transaction = transaction
    }
    
    var body: some View {
        VStack {
            TicketHeaderView(image: Image(icon: .idPayLogo), title: transaction.status == .success ? "RICEVUTA DI PAGAMENTO" : "RICEVUTA DI ANNULLAMENTO" )
            
            VStack(alignment: .leading, spacing: 10.0) {
                
                TicketField(title: "Data e ora", value: transaction.date)
                
                TicketField(title: "Iniziativa", value: transaction.description)
                
                TicketField(title: "Importo del bene", value: transaction.amount.formattedCurrency
                )

                TicketAmountRow(
                    title: "Bonus ID Pay",
                    amount: transaction.bonusAmount.formattedCurrency,
                    transactionStatus: transaction.status
                )
                
                TicketFooterView(
                    paymentProvider:
                        PaymentProviderModel(
                            name: "PagoPA S.p.A.",
                            address: "Piazza Colonna, 370 · 00187, Roma"
                        ),
                    transactionID: transaction.transactionID,
                    terminalID: transaction.terminalID
                )
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16.0)
        }
        .frame(maxWidth: 214)

    }
}

public struct ReceiptTicketDemoView: View {
    
    @State var presentShare: Bool = false
    
    public init() {}
    
    public var body: some View {
        ReceiptView (
            title: "Serve la ricevuta?",
            subtitle: "Puoi riemettere la ricevuta in un momento successivo dalla sezione ‘Storico operazioni’.",
            buttons: [
                ButtonModel(
                    type: .primary,
                    themeType: .dark,
                    title: "Invia via e-mail",
                    icon: .mail,
                    iconPosition: .left,
                    action: {
                        print("Invia via e-mail")
                    }
                ),
                ButtonModel(
                    type: .primaryBordered,
                    themeType: .dark,
                    title: "Condividi",
                    icon: .share,
                    iconPosition: .left,
                    action: {
                        presentShare = true
                    }
                ),
                ButtonModel(
                    type: .primaryBordered,
                    themeType: .dark,
                    title: "No grazie",
                    icon: .noReceipt,
                    iconPosition: .left,
                    action: {
                        print("Dismiss")
                    }
                )]
        )
        .sheet(isPresented: $presentShare, content: {
            ActivityViewController(
                activityItems: [
                    ReceiptTicketView(
                        transaction:
                            TransactionModel(
                                status: .success,
                                date: "15 Marzo 2023, 16:44",
                                description: "Bonus Vacanza",
                                amount: 5999,
                                bonusAmount: 5999,
                                transactionID: "517a-4216-840E-461f-B011-036A-0fd1-34E1",
                                terminalID: "g64tg3ryu"
                            )
                    )
                        .renderToPdf(
                            filename: "receipt.pdf",
                            location: URL.temporaryDirectory
                        )
                ]
            )
        })
    }
    
}

#Preview {
    ReceiptTicketView(
        transaction:
            TransactionModel(
                status: .success,
                date: "15 Marzo 2023, 16:44",
                description: "Bonus Vacanza",
                amount: 5999,
                bonusAmount: 5999,
                transactionID: "517a-4216-840E-461f-B011-036A-0fd1-34E1",
                terminalID: "g64tg3ryu"
            )
    )
}

#Preview {
    ReceiptTicketView(
        transaction:
            TransactionModel(
                status: .refunded,
                date: "15 Marzo 2023, 16:44",
                description: "Bonus Vacanza",
                amount: 5999,
                bonusAmount: 5999,
                transactionID: "517a-4216-840E-461f-B011-036A-0fd1-34E1",
                terminalID: "g64tg3ryu"
            )
    )
}

