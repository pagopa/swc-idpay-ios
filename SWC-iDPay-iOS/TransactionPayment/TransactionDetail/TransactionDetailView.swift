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
                        Text(viewModel.transaction.bonusAmount?.formattedCurrency ?? "-- €")
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
                            print("Nega")
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
    }
}

#Preview {
    TransactionDetailView(viewModel: TransactionDetailViewModel(networkClient: NetworkClient(environment: .staging), transaction: TransactionModel.mockedSuccessTransaction, initiative: Initiative.mocked, verifyCIEResponse: VerifyCIEResponse.mocked) )
}
