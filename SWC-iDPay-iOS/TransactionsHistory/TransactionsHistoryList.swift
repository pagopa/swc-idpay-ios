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
    @ObservedObject var viewModel: TransactionHistoryViewModel
    
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
                            
                            Text("Seleziona un elemento per visualizzare i dettagli, annullarlo o riemettere una ricevuta")
                                .font(.PAFont.body)
                                .foregroundStyle(.black)
                        }
                        
                        Spacer()
                    }
                    ForEach(viewModel.transactionHistoryList, id: \.transactionID) { transaction in
                        VStack {
                            ListItemHistory(transaction: transaction)
                                .onTapGesture {
                                    router.pushTo(.transactionDetail(viewModel: transaction))
                                }
                        
                            Divider()
                        }.padding([.leading, .trailing], Constants.mediumSpacing)
                    }
                }
            }else {
                emptyStateView
            }
        }
        .onAppear {
            viewModel.getTransactionHistory()
        }
        .showLoadingView(message: $viewModel.loadingStateMessage, isLoading: $viewModel.isLoading)
    }
    
    private var emptyStateView: some View {
        VStack {
            Spacer()
            
            Text("Non ci sono operazioni")
                .font(.PAFont.h3)
                .padding(.bottom, Constants.xsmallSpacing)
            Text("Nello storico vengono visualizzate le operazioni eseguite negli ultimi 30 giorni. Se hai bisogno di aiuto contatta l’assistenza.")
                .font(.PAFont.body)
                .multilineTextAlignment(.center)
            
            Button {
                viewModel.getTransactionHistory()
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
                                                                                                                                                    
}

#Preview {
    TransactionsHistoryList(viewModel: TransactionHistoryViewModel(networkClient: NetworkClient(environment: .staging)))
        .environmentObject(Router())
}

extension ListItemHistory {
    

    init(transaction: TransactionModel) {
       let icon = (transaction.status == .authorized) ? Image.PAIcon.checkmark : Image.PAIcon.cancelled
        self.init(iconLeft: icon, titleText: transaction.initiativeId, subTitleText: transaction.date, amountText: transaction.coveredAmount?.formattedCurrency)
    }
}
