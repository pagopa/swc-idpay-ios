//
//  TransactioDetailView.swift
//  SWC-iDPay-iOS
//
//  Created by Pier Domenico Bonamassa on 14/02/24.
//

import SwiftUI
import PagoPAUIKit

struct TransactioDetailView: View {
    
    var transaction: TransactionModel
    //    var verifyCIEResponse: VerifyCIEResponse
    
    init(transaction: TransactionModel) {
        self.transaction = transaction
        //        self.verifyCIEResponse = verifyCIEResponse
    }
    
    var body: some View {
        
        VStack {
            VStack(spacing: 0) {
                VStack {
                    VStack(alignment: .leading) {
                        Text("Confermi l'operazione?")
                            .font(.PAFont.h3)
                            .padding(.vertical, Constants.mediumSpacing)
                        ListItem(title: "IMPORTO DEL BENE", subtitle: "Sottotitolo")
                        Divider()
                        ListItem(title: "INIZIATIVA", subtitle: "Sottotitolo")
                        Divider()
                        ListItem(title: "CREDITO DISPONIBILE", subtitle: "Sottotitolo")
                        Divider()
                    }
                    .padding([.leading, .trailing], Constants.mediumSpacing)
                    
                    HStack {
                        Text("Da autorizzare")
                            .font(.PAFont.h3)
                        Spacer()
                        Text("24,54 €")
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
    TransactioDetailView(transaction: TransactionModel.mockedSuccessTransaction)
}
