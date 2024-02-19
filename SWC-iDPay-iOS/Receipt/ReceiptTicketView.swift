//
//  ReceiptTicketView.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 10/01/24.
//

import SwiftUI
import PagoPAUIKit

struct ReceiptTicketView: View {
    var receiptTicketVM: ReceiptTicketViewModel
    
    var body: some View {
        VStack {
            TicketHeaderView(image: Image(icon: .idPayLogo), title: receiptTicketVM.transaction.status.ticketDescription)
            
            VStack(alignment: .leading, spacing: 10.0) {
                
                TicketField(title: "Data e ora", value: receiptTicketVM.transaction.date)
                
                TicketField(title: "Iniziativa", value: receiptTicketVM.initiative.name)
                
                TicketField(title: "Importo del bene", value: receiptTicketVM.transaction.goodsCost.formattedCurrency
                )

                TicketAmountRow(
                    title: "Bonus ID Pay",
                    amount: receiptTicketVM.transaction.coveredAmount?.formattedCurrency ?? "N.D. €",
                    isSuccess: receiptTicketVM.transaction.status.isSuccess
                )
                
                TicketFooterView(
                    paymentProvider:
                        PaymentProviderModel(
                            name: "PagoPA S.p.A.",
                            address: "Piazza Colonna, 370 · 00187, Roma"
                        ),
                    transactionID: receiptTicketVM.transaction.transactionID,
                    terminalID: receiptTicketVM.transaction.terminalID
                )
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16.0)
        }
        .frame(maxWidth: 214)
        .padding(.vertical, 20.0)

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
                        receiptTicketVM: 
                            ReceiptTicketViewModel(
                                initiative: Initiative.mocked,
                                transaction:
                            TransactionModel.mockedSuccessTransaction
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
        receiptTicketVM:
            ReceiptTicketViewModel(
                initiative: Initiative.mocked,
                transaction:
            TransactionModel.mockedSuccessTransaction
            )
    )
}

#Preview {
    ReceiptTicketView(
        receiptTicketVM:
            ReceiptTicketViewModel(
                initiative: Initiative.mocked,
                transaction:
            TransactionModel.mockedCancelledTransaction
            )
    )
}
