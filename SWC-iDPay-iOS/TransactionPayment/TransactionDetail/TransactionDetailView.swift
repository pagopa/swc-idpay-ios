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
                    // HOME BUTTON ACTION
                    viewModel.confirmTransactionDelete()
                    //                    showDeleteTransactionDialog = true
                }
                .foregroundColor(.paPrimary)
            }
        }
        .toolbarBackground(.white, for: .navigationBar)
        .dialog(dialogModel: buildResultModel(), isPresenting: $viewModel.showErrorDialog)
        .showLoadingView(message: $viewModel.loadingStateMessage, isLoading: $viewModel.isLoading)
        
    }
    
    private func buildResultModel() -> ResultModel {
        switch viewModel.dialogState {
        case .genericError:
            return ResultModel(
                title: "Si è verificato un errore imprevisto",
                subtitle: "Per assistenza visita il sito pagopa.gov.it/assistenza oppure chiama il numero 06.4520.2323.",
                themeType: .light,
                buttons: [
                    ButtonModel(type: .primary, themeType: .light, title: "Ok, ho capito", action: {
                        viewModel.dismissDialog()
                    })
                ])
        case .confirmDelete:
            return ResultModel(
                title: "Vuoi uscire dall’operazione in corso?",
                subtitle: "L’operazione verrà annullata e sarà necessario ricominciare da capo.",
                themeType: .light,
                buttons: [
                    ButtonModel(type: .primary, themeType: .light, title: "Annulla", action: {
                        viewModel.dismissDialog()
                    }),
                    ButtonModel(type: .plain, themeType: .light, title: "Esci dal pagamento", action: {
                        viewModel.dismissDialog()
                        Task {
                            try await viewModel.deleteTransaction()
                            
                            if let routeRedirect = routeRedirect {
                                router.pop(to: routeRedirect)
                            } else {
                                router.popToRoot()
                            }
                            
                        }
                    })
                ])
        case .transactionDeleted:
            return ResultModel(
                title: "L'operazione è stata annullata",
                themeType: .light,
                buttons: [
                    ButtonModel(
                        type: .primary,
                        themeType: .light,
                        title: "Accetta nuovo bonus",
                        action: {
                            viewModel.dismissDialog()
                            router.pop(to: .initiatives(viewModel: InitiativesViewModel(networkClient: viewModel.networkClient)))
                        }),
                    ButtonModel(
                        type: .primaryBordered,
                        themeType: .light,
                        title: "Riprova",
                        action: {
                            // TODO: Repeat createTransaction and go to verifyCIE
                        })
                ])
        case .noMessage:
            return ResultModel.emptyModel
        }
    }
    
}

#Preview {
    TransactionDetailView(viewModel: TransactionDetailViewModel(networkClient: NetworkClient(environment: .staging), transaction: TransactionModel.mockedSuccessTransaction, initiative: Initiative.mocked, verifyCIEResponse: VerifyCIEResponse.mocked) )
}
