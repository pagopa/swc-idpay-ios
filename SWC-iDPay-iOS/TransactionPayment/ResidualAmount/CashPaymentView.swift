//
//  CashPaymentView.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 21/03/24.
//

import SwiftUI
import PagoPAUIKit

struct CashPaymentView: View {
    @EnvironmentObject var router: Router
    @ObservedObject var viewModel: CashPaymentViewModel

    init(viewModel: CashPaymentViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Prosegui con il pagamento del residuo in contanti")
                .multilineTextAlignment(.center)
                .font(.PAFont.h3)
                .foregroundColor(.white)
                .padding(.bottom, Constants.mediumSpacing)
            
            HStack {
                Text("Importo residuo")
                    .font(.PAFont.body)
                Spacer()
                Text(viewModel.transaction.residualAmount.formattedCurrency)
                    .font(.PAFont.h6)
            }
            .foregroundColor(.white)
            .padding(Constants.smallSpacing1)
            .background {
                RoundedRectangle(cornerRadius: Constants.xsmallSpacing)
                    .stroke(Color.white, lineWidth: 1.0)
                    .opacity(0.6)
                    .foregroundColor(Color.clear)
            }
            
            Button(action: {
                router.pop(to: .initiatives(viewModel:
                                                InitiativesViewModel(
                                                    networkClient: viewModel.networkClient)
                                           ))
            }, label: {
                Text("Accetta nuovo bonus")
            })
            .pagoPAButtonStyle(buttonType: .primary, fullwidth: false, themeType: .dark)
            .padding(.top, Constants.xlargeSpacing)
        }
        .padding(.horizontal, Constants.mediumSpacing)
        .fullScreenBackground(themeType: .dark)
    }
}

#Preview {
    CashPaymentView(viewModel:
                        CashPaymentViewModel(
                            networkClient: MockedNetworkClient(),
                            transaction: TransactionModel.mockedIdentifiedTransaction)
    )
}
