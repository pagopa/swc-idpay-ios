//
//  TransactionDetailView.swift
//  SWC-iDPay-iOS
//
//  Created by Pier Domenico Bonamassa on 14/02/24.
//

import SwiftUI
import PagoPAUIKit

struct TransactionDetailView: View, TransactionPaymentDeletableView {
    
    @ObservedObject var viewModel: TransactionDetailViewModel
    @EnvironmentObject var router: Router
    @State var showRetry: Bool = false

    init(viewModel: TransactionDetailViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        
        VStack {
            VStack(spacing: 0) {
                VStack {
                    VStack(alignment: .leading) {
                        Text("Confermi l'operazione?")
                            .font(.PAFont.h3)
                            .padding(.vertical, Constants.mediumSpacing)
                        ListItem(title: "IMPORTO DEL BENE", subtitle: viewModel.transaction.goodsCost.formattedCurrency)
                        Divider()
                        ListItem(title: "INIZIATIVA", subtitle: viewModel.initiative?.name ?? viewModel.transaction.initiativeId)
                        Divider()
                        // ListItem(title: "CREDITO DISPONIBILE", subtitle: "Sottotitolo")
                        // Divider()
                    }
                    .padding([.leading, .trailing], Constants.mediumSpacing)
                    
                    HStack {
                        Text("Da autorizzare")
                            .font(.PAFont.h3)
                        Spacer()
                        Text(viewModel.transaction.coveredAmount?.formattedCurrency ?? "-- €")
                            .font(.PAFont.h1Hero)
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
                    [ButtonModel(
                        type: .primaryBordered,
                        themeType: .light,
                        title: "Nega",
                        action: {
                            Task {
                                do {
                                    showRetry = true
                                    try await viewModel.deleteTransaction()
                                    showResultView()
                                } catch {
                                    showRetry = false
                                }
                            }
                        }
                    ),
                     ButtonModel(
                        type: .primary,
                        themeType: .light,
                        title: "Conferma",
                        action: {
                            router.pushTo(.pin(viewModel: CIEPinViewModel(networkClient: viewModel.networkClient, transaction: viewModel.transaction, verifyCIEResponse: viewModel.verifyCIEResponse, initiative: viewModel.initiative)))
                        }
                     )]
            )
        }
        .background(Color.grey100)
        .transactionToolbar(viewModel: viewModel, showBack: false)
        .dialog(dialogModel: buildDeleteDialog(viewModel: viewModel, router: router, onConfirmDelete: {
            guard showRetry == false else { return }
            Task { @MainActor in
                router.popToRoot()
            }
        }), isPresenting: $viewModel.showDeleteDialog)
        .showLoadingView(message: $viewModel.loadingStateMessage, isLoading: $viewModel.isLoading)
        
    }
    
    func showResultView() {
        router.pushTo(.thankyouPage(result: ResultModel(
            title: "L'operazione è stata annullata",
            themeType: .warning,
            buttons: [
                ButtonModel(
                    type: .primary,
                    themeType: .warning,
                    title: "Accetta nuovo bonus",
                    action: {
                        router.pop(to:.initiatives(viewModel: InitiativesViewModel(networkClient: viewModel.networkClient)))
                    }
                ),
                ButtonModel(
                    type: .primaryBordered,
                    themeType: .warning,
                    title: "Riprova",
                    action: {
                        Task {
                            // Repeat createTransaction and go to verifyCIE
                            repeatTransactionCreate(viewModel: viewModel, router: router)
                        }
                    }
                    )]
        )))
    }
}

#Preview {
    TransactionDetailView(viewModel: TransactionDetailViewModel(networkClient: NetworkClient(environment: .staging), transaction: TransactionModel.mockedSuccessTransaction, verifyCIEResponse: VerifyCIEResponse.mockedSuccessResponse, initiative: Initiative.mocked) )
}
