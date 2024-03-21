//
//  ResidualAmountOutro.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 21/03/24.
//

import SwiftUI
import PagoPAUIKit

struct ResidualAmountOutro: View {
        
    @EnvironmentObject var router: Router
    @ObservedObject var viewModel: ResidualAmountOutroViewModel

    @State private var showDialog: Bool = false
    @State private var timer: Timer?

    init(viewModel: ResidualAmountOutroViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Operazione conclusa")
                .multilineTextAlignment(.center)
                .font(.PAFont.h3)
                .foregroundColor(.white)
                .padding(.bottom, Constants.xsmallSpacing)
            
            Text("Puoi riemettere la ricevuta in un momento successivo dalla sezione ‘Storico operazioni’.")
                .multilineTextAlignment(.center)
                .font(.PAFont.body)
                .foregroundColor(.white)
                .padding(.bottom, Constants.smallSpacing)
            
            Button(action: {
                showResidualAmountDetailView()
            }, label: {
                Text("Paga l'importo residuo")
            })
            .pagoPAButtonStyle(buttonType: .primary, fullwidth: false, themeType: .dark)
            .padding(.top, Constants.mediumSpacing)
        }
        .padding(.horizontal, Constants.mediumSpacing)
        .fullScreenBackground(themeType: .dark)
        .dialog(dialogModel: 
                    ResultModel(
                        title: "C'è un importo residuo",
                        subtitle: "Rimangono da pagare \(viewModel.transaction.residualAmount.formattedCurrency)",
                        icon: .infoFilled,
                        themeType: .info,
                        buttons: [
                            ButtonModel(
                                type: .primary,
                                themeType: .info,
                                title: "Paga l'importo residuo",
                                action: {
                                    showDialog.toggle()
                                    showResidualAmountDetailView()
                                })
                            ]),
                isPresenting: $showDialog,
                onClose: {})
        .onAppear {
            timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { _ in
                showDialog = true
            }
        }
        .onDisappear {
            timer?.invalidate()
        }
    }
    
    private func showResidualAmountDetailView() {
        router.pushTo(
            .residualAmountPayment(
                viewModel: ResidualAmountViewModel(
                    networkClient: viewModel.networkClient,
                    transaction: viewModel.transaction
                ))
        )
    }
}

#Preview {
    ResidualAmountOutro(viewModel:
                            ResidualAmountOutroViewModel(
                                networkClient: MockedNetworkClient(),
                                transaction: TransactionModel.mockedIdentifiedTransaction)
    )
}
