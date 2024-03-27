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
    @State private var result: Result<MFMailComposeResult, Error>? = nil
    @State private var showOutro: Bool = false
    
    private var receiptPdfModel: ReceiptPdfModel

    init(receiptPdfModel: ReceiptPdfModel, networkClient: Requestable) {
        self.receiptPdfModel = receiptPdfModel
        self.networkClient   = networkClient
    }
    
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
                        // TODO: Manca integrazione servizio di invio email
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
                fileURL: $generatedPdfReceiptURL,
                hasDoneAction: $showOutro
            )
        })
        .onChange(of: showOutro) { newValue in
            if newValue == true {
                // On cancelled receipt, always show "Accetta nuovo bonus" in Outro
                if receiptPdfModel.transaction.status != .cancelled,
                    receiptPdfModel.transaction.goodsCost > receiptPdfModel.transaction.coveredAmount! {
                    showResidualAmountOutro()
                } else {
                    showTransactionOutro()
                }
            }
        }
    }
    
    
}

extension ReceiptConfirmView {
    
    func showTransactionOutro() {
        let forceInitiativesLoading = appManager.state != .acceptBonus
        router.pushTo(
            .outro(outroModel:
                    OutroModel(title: "Operazione conclusa",
                               subtitle: "Puoi riemettere la ricevuta in un momento successivo dalla sezione ‘Storico operazioni’.",
                               actionTitle: "Accetta nuovo bonus",
                               action: {
                                   if forceInitiativesLoading {
                                       router.popToRoot()
                                       appManager.loadHome()
                                       router.pushTo(
                                        .initiatives(viewModel: InitiativesViewModel(networkClient: networkClient))
                                       )
                                   } else {
                                       router.pop(to:
                                            .initiatives(viewModel: InitiativesViewModel(networkClient: networkClient))
                                       )
                                   }
                               })))
    }
    
    func showResidualAmountOutro() {
        guard receiptPdfModel.initiative != nil else { return }
        router.pushTo(.residualAmountOutro(viewModel: 
                                            ResidualAmountOutroViewModel(
                                                networkClient: networkClient,
                                                transaction: receiptPdfModel.transaction
                                            )))
    }
}

//#Preview {
//    ReceiptConfirmView(viewModel: ReceiptViewModel(receiptPdfModel: ReceiptPdfModel(initiative: Initiative.mocked, transaction: TransactionModel.mockedSuccessTransaction)))
//}
