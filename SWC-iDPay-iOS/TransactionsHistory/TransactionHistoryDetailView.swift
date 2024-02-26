//
//  TransactionHistoryDetailView.swift
//  SWC-iDPay-iOS
//
//  Created by Pier Domenico Bonamassa on 21/02/24.
//

import SwiftUI
import PagoPAUIKit

struct TransactionHistoryDetailView: View, TransactionPaymentDeletableView {
    @ObservedObject var viewModel: TransactionHistoryDetailViewModel
    
    @EnvironmentObject var router: Router
    @EnvironmentObject var appManager: AppStateManager
    
    @State private var generatedPdfReceiptURL: URL?
    @State private var showOutro: Bool = false
    @State private var presentShare: Bool = false
    
    init(viewModel: TransactionHistoryDetailViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            VStack(spacing: 0) {
                VStack {
                    VStack(alignment: .leading) {
                        Text("Dettaglio operazione")
                            .font(.PAFont.h3)
                            .padding(.vertical, Constants.mediumSpacing)
                        ListItem(title: "DATA e ORA", subtitle: viewModel.transaction.date, statusType: viewModel.transaction.status.operationStatus, statusDescription: viewModel.transaction.status.description )
                        Divider()
                        ListItem(title: "ID TRANSAZIONE", subtitle: viewModel.transaction.transactionID)
                        Divider()
                        ListItem(title: "INIZIATIVA", subtitle: viewModel.transaction.initiativeId)
                        Divider()
                        ListItem(title: "IMPORTO DEL BENE", subtitle: viewModel.transaction.goodsCost.formattedCurrency)
                        Divider()
                    }
                    .padding([.leading, .trailing], Constants.mediumSpacing)
                    
                    HStack {
                        Text("Bonus ID Pay")
                            .font(.PAFont.h3)
                        Spacer()
                        Text(viewModel.transaction.coveredAmount?.formattedCurrency ?? "-- €")
                            .font(.PAFont.h3)
                    }
                    .padding([.leading, .trailing], Constants.mediumSpacing)
                    .padding(.bottom, Constants.xsmallSpacing)
                }
                .background(Color.white)
                Image("ticket-final-bkg", bundle: nil)
                    .resizable(resizingMode: .tile)
                    .frame(maxWidth: .infinity, maxHeight: 23)
                    .scaledToFill()
            }
            Spacer()
            FooterButtonsView(
                buttons:
                    buildCustomButton()
            )
        }
        .background(Color.grey100)
        .dialog(dialogModel: self.buildResultModel(viewModel: self.viewModel, router: self.router, onConfirmDelete: {
            router.pushTo(.thankyouPage(result: ResultModel(
                title: "Operazione annullata",
                subtitle: "L'importo autorizzato è stato riaccreditato sull'iniziativa del cittadino",
                themeType: .success,
                buttons: [
                    ButtonModel(
                        type: .primary,
                        themeType: .success,
                        title: "Continua",
                        icon: .arrowRight,
                        action: {
                            router.pushTo(.receipt(receiptModel: ReceiptPdfModel(transaction: self.viewModel.transaction), networkClient: self.viewModel.networkClient))
                        }
                    )]
            )))
        }),
                isPresenting: $viewModel.showErrorDialog)
        .dialog(dialogModel: ResultModel(
            title: "Serve la ricevuta?",
            themeType: .light,
            buttons: [
                ButtonModel(
                    type: .primary,
                    themeType: .light,
                    title: "Invia via e-mail",
                    icon: .mail,
                    iconPosition: .left,
                    action: {
                        print("MANDA EMAIL")
                    }
                ),
                ButtonModel(
                    type: .primaryBordered,
                    themeType: .light,
                    title: "Condividi",
                    icon: .share,
                    iconPosition: .left,
                    action: {
                        viewModel.showReceiptDialog.toggle()
                        guard let _ = generatedPdfReceiptURL else { return }
                        presentShare = true
                    }
                )
            ]
        ), isPresenting: $viewModel.showReceiptDialog, onClose: {
            self.viewModel.showReceiptDialog = false
        })
        .showLoadingView(message: $viewModel.loadingStateMessage, isLoading: $viewModel.isLoading)
        .onChange(of: showOutro) { newValue in
            if newValue == true {
                presentShare = false
                router.pushTo(.outro(outroModel: OutroModel(title: "Operazione conclusa", subtitle: "Puoi riemettere la ricevuta in un momento successivo dalla sezione ‘Storico operazioni’.", actionTitle: "Torna alla home", action: {
                    router.popToRoot()
                    appManager.login()
                })))
            }
        }
        .sheet(isPresented: $presentShare, content: {
            ActivityViewController(
                fileURL: self.$generatedPdfReceiptURL,
                hasDoneAction: self.$showOutro
            )
        })
        .onAppear(){
            Task {
                generatePdfReceipt()
            }
        }
    }
    
    func buildCustomButton() -> [ButtonModel] {
        switch self.viewModel.transaction.status {
        case .authorized:
            var buttons: [ButtonModel] = []
            if evaluateOperation() {
                buttons.append(ButtonModel(
                    type: .primaryBordered,
                    themeType: .light,
                    title: "Annulla operazione",
                    action: {
                        viewModel.confirmHistoryTransactionDelete()
                    }
                ))
            }
            buttons.append(ButtonModel(
                type: .primary,
                themeType: .light,
                title: "Emetti ricevuta",
                action: {
                    self.viewModel.showReceiptDialog.toggle()
                }
             ))
            return buttons
        case .cancelled:
            return [ButtonModel(
                type: .primary,
                themeType: .light,
                title: "Emetti ricevuta",
                action: {
                    self.viewModel.showReceiptDialog.toggle()
                }
            )]
        default:
            return [ButtonModel(
                type: .primary,
                themeType: .light,
                title: "Emetti ricevuta",
                action: {
                    self.viewModel.showReceiptDialog.toggle()
                }
            )]
        }
    }

    
    func evaluateOperation() -> Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM yyyy, HH:mm"
        
        if let operationDate = formatter.date(from: self.viewModel.transaction.date) {
            let components = Calendar.current.dateComponents([.day], from: operationDate, to: Date())
            if let day = components.day {
                return day < 3
            }
        }
        return false
    }
    
    @MainActor
    func generatePdfReceipt() {
        
        self.generatedPdfReceiptURL = ReceiptPdfBuilderView(
            receiptTicketVM: ReceiptPdfModel(transaction: self.viewModel.transaction)
        )
        .renderToPdf(
            filename: "receipt.pdf",
            location: URL.temporaryDirectory
        )
    }
}

#Preview {
    TransactionHistoryDetailView(viewModel: TransactionHistoryDetailViewModel(transaction: TransactionModel.fallbackTransaction, networkClient: NetworkClient(environment: .staging)))
        .environmentObject(Router())
}
