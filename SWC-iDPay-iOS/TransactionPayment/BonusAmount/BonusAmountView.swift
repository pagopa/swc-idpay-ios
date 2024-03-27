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
    @State var shouldShowAuthModeDialog: Bool = false

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
                isPresenting: $shouldShowAuthModeDialog,
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
                    #if DEBUG
                    if UITestingHelper.isUITesting {
                       shouldShowAuthModeDialog = true
                        return
                    }
                    #endif
                    guard CIEReader.isNFCEnabled() else {
                        proceedToQrCodeAuth()
                        return
                    }
                    shouldShowAuthModeDialog = true
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
                            shouldShowAuthModeDialog = false
                            proceedToCieAuth()
                        }
                    ),
                    ButtonModel(
                        type: .primaryBordered,
                        themeType: .light,
                        title: "Identificazione con ",
                        icon: .io,
                        action: {
                            shouldShowAuthModeDialog = false
                            proceedToQrCodeAuth()
                        }
                    )
                ]
            )
        
    }
    
    private func proceedToCieAuth() {
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
    
    private func proceedToQrCodeAuth() {
        guard let transactionData = viewModel.transactionData else {
            // TODO: Show error if transactionData i nil
            return
        }
        router.pushTo(.qrCodeAuth(viewModel:
                                    QRCodeViewModel(
                                        networkClient: viewModel.networkClient,
                                        transactionData: transactionData,
                                        initiative: viewModel.initiative
                                    )))
    }
}

#Preview {
    BonusAmountView(
        viewModel: BonusAmountViewModel(networkClient: NetworkClient(environment: .staging),
                                             initiative: Initiative.mocked)
    )
}
