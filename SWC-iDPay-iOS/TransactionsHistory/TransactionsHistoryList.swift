//
//  TransactionsHistoryList.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 07/02/24.
//

import SwiftUI
import PagoPAUIKit

struct TransactionsHistoryList: View {
    
    @EnvironmentObject var router: Router
    @EnvironmentObject var appManager: AppStateManager
    @ObservedObject var viewModel: TransactionHistoryViewModel
    @State private var showHelp: Bool = false
    
    init(viewModel: TransactionHistoryViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            if viewModel.transactionHistoryList.count > 0 {
                ScrollView {
                    VStack {
                        VStack(alignment: .leading) {
                            Text("Storico operazioni")
                                .font(.PAFont.h3)
                                .foregroundStyle(Color.paBlack)
                            
                            Text("Seleziona un elemento per visualizzare i dettagli," +
                                 "annullarlo o riemettere una ricevuta"
                            )
                            .font(.PAFont.body)
                            .foregroundStyle(.black)
                        }
                        
                        Spacer()
                    }
                    
                    ForEach(viewModel.transactionHistoryList, id: \.milTransactionId) { transaction in
                        Button(action: {
                            router.pushTo(
                                .transactionDetail(
                                    viewModel: TransactionHistoryDetailViewModel(
                                        transaction: transaction,
                                        networkClient: self.viewModel.networkClient
                                    )
                                )
                            )
                        }, label: {
                            VStack {
                                ListItemHistory(transaction: transaction)
                                Divider()
                            }
                        })
                        .padding([.leading, .trailing], Constants.mediumSpacing)
                        .accessibilityIdentifier("historyRowItem")
                    }
                }
            } else {
                emptyStateView
            }
        }
        .onAppear {
            viewModel.getTransactionHistory()
        }
        .showLoadingView(message: $viewModel.loadingStateMessage, isLoading: $viewModel.isLoading)
        .fullScreenCover(isPresented: $showHelp) {
            HelpView()
                .ignoresSafeArea()
        }
        .fullScreenCover(isPresented: $viewModel.showError) {
            getErrorView()
        }
    }
    
    private var emptyStateView: some View {
        VStack {
            Spacer()
            
            Text("Non ci sono operazioni")
                .font(.PAFont.h3)
                .padding(.bottom, Constants.xsmallSpacing)
            Text("Nello storico vengono visualizzate le operazioni eseguite negli" +
                 "ultimi 30 giorni. Se hai bisogno di aiuto contatta l’assistenza."
            )
            .font(.PAFont.body)
            .multilineTextAlignment(.center)
            
            Button {
                showHelp.toggle()
            } label: {
                Text("Vai all'assistenza")
            }
            .pagoPAButtonStyle(buttonType: .primaryBordered, fullwidth: false)
            .padding(.vertical, Constants.xlargeSpacing)
            
            Spacer()
        }
        .foregroundColor(.paBlack)
        .padding(Constants.mediumSpacing)
    }
       
    fileprivate func getErrorView() -> ThankyouPage {
        return ThankyouPage(
            result: ResultModel(
                title: HTTPResponseError.historyListError.reason,
                subtitle: "Riprova tra qualche minuto",
                themeType: .error,
                buttons: [
                    ButtonModel(
                        type: .primary,
                        themeType: .error,
                        title: "Torna alla home",
                        action: {
                            appManager.loadHome()
                        }
                    )
                ]
            )
        )
    }
}

#Preview {
    TransactionsHistoryList(viewModel: TransactionHistoryViewModel(networkClient: NetworkClient(environment: .staging)))
        .environmentObject(Router())
}
