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
                        ListItem(title: "INIZIATIVA", subtitle: viewModel.initiative.name)
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
                                try await viewModel.deleteTransaction()
                            }
                        }
                    ),
                     ButtonModel(
                        type: .primary,
                        themeType: .light,
                        title: "Conferma",
                        action: {
                            router.pushTo(.pin(viewModel: CIEPinViewModel(networkClient: viewModel.networkClient, initiative: viewModel.initiative, transaction: viewModel.transaction, verifyCIEResponse: viewModel.verifyCIEResponse)))
                        }
                     )]
            )
        }
        .background(Color.grey100)
        .transactionToolbar(viewModel: viewModel, showBack: false)
        .dialog(dialogModel: buildResultModel(viewModel: viewModel, router: router, retryAction: {
            Task {
                // Repeat createTransaction and go to verifyCIE
                let createTransactionResponse = try await viewModel.createTransaction()
                await MainActor.run {
                    router.pop(last: 2)
                    router.pushTo(.cieAuth(viewModel: CIEAuthViewModel(networkClient: viewModel.networkClient, transactionData: createTransactionResponse, initiative: viewModel.initiative)))
                }
            }
        }), isPresenting: $viewModel.showErrorDialog)
        .showLoadingView(message: $viewModel.loadingStateMessage, isLoading: $viewModel.isLoading)
        
    }
        
}

#Preview {
    TransactionDetailView(viewModel: TransactionDetailViewModel(networkClient: NetworkClient(environment: .staging), transaction: TransactionModel.mockedSuccessTransaction, initiative: Initiative.mocked, verifyCIEResponse: VerifyCIEResponse.mocked) )
}
