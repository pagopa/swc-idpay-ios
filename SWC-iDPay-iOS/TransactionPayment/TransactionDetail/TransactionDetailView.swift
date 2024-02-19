//
//  TransactionDetailView.swift
//  SWC-iDPay-iOS
//
//  Created by Pier Domenico Bonamassa on 14/02/24.
//

import SwiftUI
import PagoPAUIKit

struct TransactionDetailView: View {
    
    @ObservedObject var viewModel: TransactionDetailViewModel
    @EnvironmentObject var router: Router
    @State var showDeleteTransactionDialog: Bool = false
    @State var showDenyTransactionDialog: Bool = false
    @State private var routeRedirect: Route?
    
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
                        //                        ListItem(title: "CREDITO DISPONIBILE", subtitle: "Sottotitolo")
                        //                        Divider()
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
                                await MainActor.run {
                                    showDenyTransactionDialog = true
                                }
                            }
                        }
                    ),
                     ButtonModel(
                        type: .primary,
                        themeType: .light,
                        title: "Conferma",
                        action: {
                            print("Conferma")
                        }
                     )]
            )
        }
        .background(Color.grey100)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                HomeButton {
                    print("Home btn tapped")
                    showDeleteTransactionDialog = true
                }
                .foregroundColor(.paPrimary)
            }
        }
        .toolbarBackground(.white, for: .navigationBar)
        .showDeleteTransactionDialog(
            isPresenting: $showDeleteTransactionDialog,
            transactionId: viewModel.transaction.transactionID,
            networkClient: viewModel.networkClient,
            onDeleted: {
                showDenyTransactionDialog = false
                if let routeRedirect = routeRedirect {
                    router.pop(to: routeRedirect)
                } else {
                    router.popToRoot()
                }
            })
        .dialog(dialogModel:
                    ResultModel(
                        title: "L'operazione è stata annullata",
                        themeType: .light,
                        buttons: [
                            ButtonModel(
                                type: .primary,
                                themeType: .light,
                                title: "Accetta nuovo bonus",
                                action: {
                                    router.pop(to: .initiatives(viewModel: InitiativesViewModel(networkClient: viewModel.networkClient)))
                                }),
                            ButtonModel(
                                type: .primaryBordered,
                                themeType: .light,
                                title: "Riprova",
                                action: {
                                    // TODO: Repeat createTransaction and go to verifyCIE
                                })
                        ]), isPresenting: $showDenyTransactionDialog
        )
    }
    
}

#Preview {
    TransactionDetailView(viewModel: TransactionDetailViewModel(networkClient: NetworkClient(environment: .staging), transaction: TransactionModel.mockedSuccessTransaction, initiative: Initiative.mocked, verifyCIEResponse: VerifyCIEResponse.mocked) )
}
