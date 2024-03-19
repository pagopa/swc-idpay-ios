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
            .dialog(dialogModel: buildDeleteDialog(viewModel: viewModel, router: router, onConfirmDelete: {
                Task { @MainActor in
                    router.popToRoot()
                }
            }), isPresenting: $viewModel.showDeleteDialog)
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
                let transaction = try await viewModel.pollTransactionStatus()
                
                await MainActor.run {
                    router.pushTo(.transactionConfirm(viewModel: TransactionDetailViewModel(networkClient: viewModel.networkClient, transaction: transaction, verifyCIEResponse: verifyCIEResponse, initiative: viewModel.initiative)))
                }
            } catch {
                switch error {
                case HTTPResponseError.maxRetriesExceeded, HTTPResponseError.coveredAmountInconsistent:
                    router.pushTo(
                        .thankyouPage(
                            result: ResultModel(
                                title: "La sessione è scaduta",
                                subtitle:"Se vuoi procedere con il pagamento, prova ad autorizzarlo di nuovo.",
                                icon: .pendingDark,
                                themeType: .info,
                                buttons: [
                                    ButtonModel(
                                        type: .primary,
                                        themeType: .info,
                                        title: "Riprova",
                                        action: {
                                            router.pop()
                                        }),
                                    ButtonModel(
                                        type: .primaryBordered,
                                        themeType: .info,
                                        title: "Accetta nuovo bonus",
                                        action: {
                                            router.pop(to: .initiatives(viewModel: InitiativesViewModel(networkClient: viewModel.networkClient)))
                                        })
                                ])))
                case CIEReaderError.scanNotSupported:
                    print("NFC not available")
                case is CIEAuthError:
                    router.pushTo(
                        .thankyouPage(
                            result: ResultModel(
                                title: "Errore nella verifica della transazione",
                                subtitle:"Non è stato possibile verificare la transazione",
                                themeType: .info,
                                buttons: [
                                    ButtonModel(
                                        type: .primaryBordered,
                                        themeType: .info,
                                        title: "Accetta nuovo bonus",
                                        action: {
                                            router.pop(to: .initiatives(viewModel: InitiativesViewModel(networkClient: viewModel.networkClient)))
                                        })
                                ])))
                default:
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
