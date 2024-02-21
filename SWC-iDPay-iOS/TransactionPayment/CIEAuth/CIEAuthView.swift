//
//  CIEAuthView.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 15/02/24.
//

import SwiftUI
import PagoPAUIKit
import CIEScanner

struct CIEAuthView: View, TransactionPaymentDeletableView {
    
    @EnvironmentObject var router: Router
    @ObservedObject var viewModel: CIEAuthViewModel
    
    var body: some View {
        ZStack {
            Color
                .grey50
                .ignoresSafeArea()

            VStack {
                Text("IMPORTO DEL BENE")
                    .font(.PAFont.caption)
                    .foregroundColor(.paBlack)
                    .padding(.top, Constants.mediumSpacing)
                
                Group {
                    Text(viewModel.transactionData.goodsCost.formattedAmountNoCurrency)
                        .font(.PAFont.h1Hero)
                    +
                    Text(" €")
                        .font(.PAFont.caption)
                }
                .foregroundColor(.paBlack)
                .padding(Constants.smallSpacing)
                
                    Spacer()
                    retryCIEScanView
                    Spacer()
                
            }
            .padding(Constants.mediumSpacing)
            .transactionToolbar(viewModel: viewModel)
            .dialog(dialogModel: buildResultModel(viewModel: viewModel, router: router, retryAction: {
                Task {
                    // Repeat createTransaction and start CIE scan
                    let createTransactionResponse = try await viewModel.createTransaction()
                    viewModel.transactionData = createTransactionResponse
                    startCIEScan()
                }
            }), isPresenting: $viewModel.showErrorDialog)
            .showLoadingView(message: $viewModel.loadingStateMessage, isLoading: $viewModel.isLoading)
        }
        .onAppear {
            startCIEScan()
        }
    }
    
    @ViewBuilder
    private var retryCIEScanView: some View {
        VStack(spacing: Constants.smallSpacing) {
            
            Text("IDENTIFICAZIONE CON CIE")
                .foregroundColor(.paPrimary)
                .font(.PAFont.caption)
            
            Text("Appoggia la CIE sul dispositivo, in alto")
                .multilineTextAlignment(.center)
                .foregroundColor(.paBlack)
                .font(.PAFont.h4)
                .padding(.bottom, Constants.xsmallSpacing)
            
            Image("cie", bundle: nil)
            
            Button("Riprova") {
                startCIEScan()
            }
            .pagoPAButtonStyle(buttonType: .primary)
            .padding(.vertical, Constants.xsmallSpacing)
        }
        .padding(Constants.mediumSpacing)
        .background(
            RoundedRectangle(cornerRadius: 10.0)
                .fill(Color.white)
        )
    }

    private func startCIEScan() {
        Task {
            do {
                try await viewModel.readCIE()
                let verifyCIEResponse = try await viewModel.verifyCIE()
                guard let transaction = try await viewModel.pollTransactionStatus() else {
                    // TODO: Show error
                    return
                }
                await MainActor.run {
                    router.pushTo(.transactionConfirm(viewModel: TransactionDetailViewModel(networkClient: viewModel.networkClient, transaction: transaction, initiative: viewModel.initiative, verifyCIEResponse: verifyCIEResponse)))
                }
            } catch {
                if let cieError = error as? CIEReaderError {
                    switch cieError {
                    case .scanNotSupported:
                        // TODO: Show error NFC not available
                        print("NFC not available")
                    default:
                        break
                    }
                } else if let cieAuthError = error as? CIEAuthError {
                    router.pushTo(.thankyouPage(result: ResultModel(title: "Errore nella verifica della transazione", subtitle:"Non è stato possibile verificare la transazione", themeType: .info, buttons: [
                        ButtonModel(type: .primaryBordered, themeType: .info, title: "Accetta nuovo bonus", action: {
                            router.pop(to: .initiatives(viewModel: InitiativesViewModel(networkClient: viewModel.networkClient)))
                        })
                    ])))
                } else {
                    print("Error:\(error.localizedDescription)")
                }
            }
        }
        
    }
}

#Preview {
    CIEAuthView(
        viewModel:
            CIEAuthViewModel(
                networkClient: NetworkClient(environment: .staging),
                transactionData: CreateTransactionResponse.mockedCreated,
                initiative: Initiative.mocked
            )
    )
}
