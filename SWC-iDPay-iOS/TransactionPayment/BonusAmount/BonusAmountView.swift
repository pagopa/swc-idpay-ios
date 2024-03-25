//
//  BonusAmountView.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 18/01/24.
//
import SwiftUI
import PagoPAUIKit
import CIEScanner

struct BonusAmountView: View {
    @EnvironmentObject var router: Router
    @ObservedObject var viewModel: BonusAmountViewModel
    @State var isReadingCIE: Bool = false
    
    var body: some View {
        ZStack {
            backgroundView
            
            VStack {
                Text("IMPORTO DEL BENE")
                    .font(.PAFont.caption)
                    .foregroundColor(.paBlack)
                    .padding(.top, Constants.mediumSpacing)
                
                Group {
                    Text(viewModel.amountText)
                        .font(.PAFont.h1Hero)
                    +
                    Text(" €")
                        .font(.PAFont.caption)
                }
                .foregroundColor(.paBlack)
                .padding(Constants.smallSpacing)
                
                paymentView
            }
            .padding(Constants.mediumSpacing)
            .dialog(
                dialogModel: showAuthDialog(),
                isPresenting: $viewModel.showAuthDialog,
                onClose: {}
            )
            .dialog(dialogModel: buildGenericErrorResultModel {
                viewModel.showError.toggle()
            }, isPresenting: $viewModel.showError)
            .showLoadingView(message: $viewModel.loadingStateMessage, isLoading: $viewModel.isLoading)
        }
    }
    
    @ViewBuilder
    private var backgroundView: some View {
        if isReadingCIE {
            Color
                .grey50
                .ignoresSafeArea()
        } else {
            Color
                .white
                .ignoresSafeArea()
        }
    }
    
    @ViewBuilder
    private var paymentView: some View {
        Spacer()
        NumberPad(.numeric, string: $viewModel.amountText)
        Spacer()
        CustomLoadingButton(
            buttonType: .primary,
            isLoading: $viewModel.isCreatingTransaction) {
                Task {
                    try await viewModel.createTransaction()
                }
            } label: {
                Text("Conferma")
            }
            .disabled(viewModel.amountText == "0,00")
    }
    
    private func showAuthDialog() -> ResultModel {
        ResultModel(
                title: "Come vuoi identificarti?",
                themeType: ThemeType.light,
                buttons:[
                    ButtonModel(
                        type: .primary,
                        themeType: .light,
                        title: "Identificazione con CIE",
                        action: {
                            viewModel.showAuthDialog = false
                            guard let transactionData = viewModel.transactionData else {
                                // TODO: Show error if transactionData i nil
                                return
                            }
                            router.pushTo(.cieAuth(viewModel: 
                                                    CIEAuthViewModel(
                                                        networkClient: viewModel.networkClient,
                                                        transactionData: transactionData,
                                                        initiative: viewModel.initiative
                                                    )))
                        }
                    ),
                    ButtonModel(
                        type: .primaryBordered,
                        themeType: .light,
                        title: "Identificazione con ",
                        icon: .io,
                        action: {
                            viewModel.showAuthDialog = false
                            guard let transactionData = viewModel.transactionData else {
                                // TODO: Show error if transactionData i nil
                                return
                            }
                            router.pushTo(.qrCodeAuth(viewModel:
                                                        QRCodeViewModel(networkClient: viewModel.networkClient,
                                                                        transactionData: transactionData
                                                                       )))
                        }
                    )
                ]
            )
        
    }
}

#Preview {
    BonusAmountView(
        viewModel: BonusAmountViewModel(networkClient: NetworkClient(environment: .staging),
                                             initiative: Initiative.mocked)
    )
}
