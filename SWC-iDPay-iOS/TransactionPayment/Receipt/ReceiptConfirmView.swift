//
//  ReceiptConfirmView.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 23/02/24.
//

import SwiftUI
import PagoPAUIKit
import MessageUI

public struct ReceiptConfirmView: View, ReceiptGenerator {
    
    var networkClient: Requestable
    
    @EnvironmentObject var router: Router
    @EnvironmentObject var appManager: AppStateManager
    
    @State private var presentShare: Bool = false
    @State private var generatedPdfReceiptURL: URL?
    @State private var result: Result<MFMailComposeResult, Error>?
    @State private var showOutro: Bool = false
    
    private var receiptPdfModel: ReceiptPdfModel

    init(receiptPdfModel: ReceiptPdfModel, networkClient: Requestable) {
        self.receiptPdfModel = receiptPdfModel
        self.networkClient   = networkClient
    }
    
    public var body: some View {
        ReceiptView(
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
                        generatedPdfReceiptURL = generatePdfReceipt(model: self.receiptPdfModel)
                        // TODO: Chiamare servizio di invio email
                        showOutro = true
                    }
                ),
                ButtonModel(
                    type: .primaryBordered,
                    themeType: .dark,
                    title: "Condividi",
                    icon: .share,
                    iconPosition: .left,
                    action: {
                        generatedPdfReceiptURL = generatePdfReceipt(model: self.receiptPdfModel)
                        presentShare = true
                    }
                ),
                ButtonModel(
                    type: .primaryBordered,
                    themeType: .dark,
                    title: "No, grazie",
                    icon: .noReceipt,
                    iconPosition: .left,
                    action: {
                        showOutro = true
                    }
                )]
        )
        .sheet(isPresented: $presentShare, content: {
            ActivityViewController(
                fileURL: self.$generatedPdfReceiptURL,
                hasDoneAction: self.$showOutro
            )
        })
        .onChange(of: showOutro) { newValue in
            if newValue == true {
                if let _ = receiptPdfModel.initiative {
                    // initiative payment flow
                    showTransactionPaymentOutro()
                } else {
                    // transaction history flow
                    showCancelTransactionOutro()
                }
            }
        }
    }
        
    func showCancelTransactionOutro() {
        router.pushTo(
            .outro(
                outroModel:
                    OutroModel(
                        title: "Operazione conclusa",
                        subtitle: "Puoi riemettere la ricevuta in un momento successivo dalla sezione ‘Storico operazioni’.",
                        actionTitle: "Torna alla home",
                        action: {
                            router.popToRoot()
                            appManager.loadHome()
                        }
                    )
            )
        )
    }
    
    func showTransactionPaymentOutro() {
        router.pushTo(
            .outro(
                outroModel: OutroModel(
                    title: "Operazione conclusa",
                    subtitle: "Puoi riemettere la ricevuta in un momento successivo dalla sezione ‘Storico operazioni’.",
                    actionTitle: "Accetta nuovo bonus",
                    action: {
                        router.pop(to: .initiatives(viewModel: InitiativesViewModel(networkClient: networkClient)))
                    }
                )
            )
        )
    }
}

// #Preview {
//    ReceiptConfirmView(viewModel: ReceiptViewModel(receiptPdfModel: ReceiptPdfModel(initiative: Initiative.mocked, transaction: TransactionModel.mockedSuccessTransaction)))
// }
