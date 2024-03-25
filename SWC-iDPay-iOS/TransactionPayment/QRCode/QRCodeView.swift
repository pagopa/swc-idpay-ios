//
//  QRCodeView.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 22/03/24.
//

import SwiftUI
import PagoPAUIKit

struct QRCodeView: View, TransactionPaymentDeletableView {
    @EnvironmentObject var router: Router
    @ObservedObject var viewModel: QRCodeViewModel
    @State private var showQRDialog: Bool = false
    @State private var showWaitingView: Bool = false

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
                    qrCodeView
                    Spacer()
                
            }
            .padding(Constants.mediumSpacing)
            .transactionToolbar(viewModel: viewModel)
            .dialogCode(
                title: "Problemi con il QR?", 
                subtitle: "Entra sull’app IO, vai nella sezione Inquadra e digita il codice:",
                codeValue: viewModel.transactionData.trxCode.uppercased(),
                isPresenting: $showQRDialog,
                onClose: {})
            .dialog(dialogModel:
                        buildDeleteDialog(
                            viewModel: viewModel,
                            router: router,
                            onConfirmDelete: {
                                Task { @MainActor in
                                    router.popToRoot()
                                }
                            }),
                    isPresenting: $viewModel.showDeleteDialog)
            .waitingView(
                title: "Attendi autorizzazione",
                subtitle: "Per proseguire è necessario autorizzare l’operazione sull’app IO",
                buttons: [
                    ButtonModel(
                        type: .plain,
                        themeType: .info,
                        title: "Annulla",
                        action: {
                            //TODO: Flusso annullamento
                            print("Annulla operazione")
                        })
                ],
                isPresenting: $showWaitingView)
            .showLoadingView(message: $viewModel.loadingStateMessage, isLoading: $viewModel.isLoading)
        }
        .task {
            do {
                try await viewModel.pollTransactionStatus()
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
                                                try await viewModel.deleteTransaction(
                                                    loadingMessage: "Attendi qualche istante")
                                                repeatTransactionCreate(
                                                    viewModel: viewModel,
                                                    router: router)
                                            }
                                        }),
                                    ButtonModel(
                                        type: .primaryBordered,
                                        themeType: .info,
                                        title: "Accetta nuovo bonus",
                                        action: {
                                            Task {
                                                try await viewModel.deleteTransaction(
                                                    loadingMessage: "Attendi qualche istante")
                                                router.pop(to: .initiatives(
                                                    viewModel: InitiativesViewModel(
                                                        networkClient: viewModel.networkClient)))
                                            }
                                        })
                                ])))
                default:
                    print("Error:\(error.localizedDescription)")
                    viewModel.showError()
                }

            }
        }
        .onChange(of: viewModel.qrCodePollingStatus) { qrCodePollingStatus in
            
            switch qrCodePollingStatus {
            case .identified:
                showWaitingView = true
            case .authorized:
                showWaitingView = false
                showAuthorizedView()
            case .canceled:
                showWaitingView = false
                showOperationCanceled()
            default:
                showWaitingView = false
                break
            }
        }
        
    }
    
    @ViewBuilder
    private var qrCodeView: some View {
        VStack(spacing: Constants.smallSpacing) {
            
            Text("IDENTIFICAZIONE CON ID")
                .foregroundColor(.paPrimary)
                .font(.PAFont.caption)
            
            Text("Inquadra il codice QR con il tuo smartphone")
                .multilineTextAlignment(.center)
                .foregroundColor(.paBlack)
                .font(.PAFont.h4)
                .padding(.bottom, Constants.xsmallSpacing)
            
            ZStack(alignment: .center) {
                Image(uiImage: QRCodeGenerator.generateQRCode(from: viewModel.transactionData.qrCode))
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
                    .frame(
                        width: Constants.qrCodeSize,
                        height: Constants.qrCodeSize)

                Image(icon: .io)
                    .foregroundColor(.paPrimary)
                    .background {
                        Color.white
                            .frame(
                                width: Constants.largeSpacing,
                                height: Constants.largeSpacing)
                    }
            }
            
            Button("Problemi con il QR?") {
                showQRDialog.toggle()
            }
            .pagoPAButtonStyle(buttonType: .primaryBordered)
            .padding(.vertical, Constants.xsmallSpacing)
        }
        .padding(Constants.mediumSpacing)
        .background(
            RoundedRectangle(cornerRadius: 10.0)
                .fill(Color.white)
        )
    }

}

extension QRCodeView {
    
    func showAuthorizedView() {
        router.pushTo(
            .thankyouPage(result:
                            ResultModel(
                                title: "Hai pagato \(viewModel.transaction!.coveredAmount!.formattedCurrency)",
                                themeType: .success,
                                buttons: [
                                    ButtonModel(
                                        type: .primary,
                                        themeType: .success,
                                        title: "Continua",
                                        action: {
                                            router.pushTo(
                                                .receipt(receiptModel:
                                                            ReceiptPdfModel(
                                                                transaction: viewModel.transaction!,
                                                                initiative: viewModel.initiative),
                                                         networkClient: viewModel.networkClient))
                                        })
                                ])))
        
    }
    
    func showOperationCanceled() {
        router.pushTo(
            .thankyouPage(result:
                            ResultModel(
                                title: "L'operazione è stata annullata",
                                themeType: .warning,
                                buttons: [
                                    ButtonModel(
                                        type: .primary,
                                        themeType: .warning,
                                        title: "Accetta nuovo bonus",
                                        action: {
                                            Task {
                                                try await viewModel.deleteTransaction(loadingMessage: "Attendi qualche istante")
                                                router.pop(to: .initiatives(
                                                    viewModel: InitiativesViewModel(networkClient: viewModel.networkClient)))
                                            }
                                        }),
                                    ButtonModel(
                                        type: .primaryBordered,
                                        themeType: .warning,
                                        title: "Riprova",
                                        action: {
                                            Task {
                                                try await viewModel.deleteTransaction(loadingMessage: "Attendi qualche istante")
                                                repeatTransactionCreate(
                                                    viewModel: viewModel,
                                                    router: router)
                                            }
                                        })
                                ])))

    }
}

#Preview {
    QRCodeView(viewModel: QRCodeViewModel(
        networkClient: MockedNetworkClient(),
        transactionData: CreateTransactionResponse.mockedCreated))
    .environmentObject(Router())
}
