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
                guard let verifyCIEResponse = try await viewModel.verifyCIE() else {
                    return
                }
                let transaction = try await viewModel.pollTransactionStatus()
                router.pushTo(.transactionConfirm(viewModel: TransactionDetailViewModel(networkClient: viewModel.networkClient, transaction: transaction, verifyCIEResponse: verifyCIEResponse, initiative: viewModel.initiative)))
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
                                            Task {
                                                try await viewModel.deleteTransaction(loadingMessage: "Attendi qualche istante")
                                                // Repeat createTransaction and go to verifyCIE
                                                repeatTransactionCreate(viewModel: viewModel, router: router)
                                            }
                                        }),
                                    ButtonModel(
                                        type: .primaryBordered,
                                        themeType: .info,
                                        title: "Accetta nuovo bonus",
                                        action: {
                                            Task {
                                                try await viewModel.deleteTransaction(loadingMessage: "Attendi qualche istante")
                                                router.pop(to: .initiatives(viewModel: InitiativesViewModel(networkClient: viewModel.networkClient)))
                                            }
                                        })
                                ])))
                    // TODO: Gestione errori verifyCIE specifici
//                case is CIEAuthError:
//                    router.pushTo(
//                        .thankyouPage(
//                            result: ResultModel(
//                                title: "Si è verificato un errore imprevisto",
//                                subtitle:"Non è possibile completare l'operazione.",
//                                themeType: .error,
//                                buttons: [
//                                    ButtonModel(
//                                        type: .primary,
//                                        themeType: .error,
//                                        title: "Autorizza con",
//                                        icon: .io,
//                                        action: {
//                                            //Errore verifyCie: riparte da flusso QRcode
//                                            router.pop(to: .bonusAmount(
//                                                viewModel: BonusAmountViewModel(
//                                                    networkClient: viewModel.networkClient,
//                                                    initiative: viewModel.initiative!)))
//                                            router.pushTo(.qrCodeAuth(
//                                                viewModel: QRCodeViewModel(
//                                                    networkClient: viewModel.networkClient,
//                                                    transactionData: viewModel.transactionData)))
//                                        }),
//                                    ButtonModel(
//                                        type: .primaryBordered,
//                                        themeType: .error,
//                                        title: "Accetta nuovo bonus",
//                                        action: {
//                                            router.pop(to: .initiatives(viewModel: InitiativesViewModel(networkClient: viewModel.networkClient)))
//                                        })
//                                ])))
                default:
                    #if DEBUG
                    print("Error:\(error.localizedDescription)")
                    #endif
                    if let error = error as? HTTPResponseError, error == .unauthorized {
                        return
                    }
                    viewModel.showError()
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
