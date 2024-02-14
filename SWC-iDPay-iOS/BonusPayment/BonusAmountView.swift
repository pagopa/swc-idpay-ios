//
//  BonusAmountView.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 18/01/24.
//
import SwiftUI
import PagoPAUIKit
import CIEScanner

struct BonusAmountView : View {
    @EnvironmentObject var router: Router
    @ObservedObject var viewModel: BonusAmountViewModel
    @State var dialogModel: ResultModel = ResultModel.emptyModel
    @State var isPresentingDialog: Bool = false
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
                
                if isReadingCIE {
                    Spacer()
                    retryCIEScanView
                    Spacer()

                } else {
                    paymentView
                }
                
            }
            .padding(Constants.mediumSpacing)
            .dialog(
                dialogModel: dialogModel,
                isPresenting: $isPresentingDialog,
                onClose:{
                    print("Do some action on close")
                }
            )
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
            isLoading: $viewModel.isLoading) {
                Task {
                    try await viewModel.createTransaction()
                    self.showAuthModeDialog()
                }
            } label: {
                Text("Conferma")
            }
            .disabled(viewModel.amountText == "0,00")
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
            self.isReadingCIE = true
            do {
                try await viewModel.readCIE()
                let verifyCIEResponse = try await viewModel.verifyCIE()
                let transaction = try await viewModel.pollTransactionStatus()
                // TODO: router.push(to: .transactionDetail(transaction: transaction, verifyCIEResponse: verifyCIEResponse))
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
    
    private func showAuthModeDialog() {
        self.dialogModel = ResultModel(
            title: "Come vuoi identificarti?",
            themeType: ThemeType.light,
            buttons:[
                ButtonModel(
                    type: .primary,
                    themeType: .light,
                    title: "Identificazione con CIE",
                    action: {
                        print("Identificazione con CIE")
                        self.isPresentingDialog = false
                        startCIEScan()
                    }
                ),
                ButtonModel(
                    type: .primaryBordered,
                    themeType: .light,
                    title: "Identificazione con ",
                    icon: .io,
                    action: {
                        print("Accetta nuovo bonus")
                    }
                )
            ]
        )
        
        isPresentingDialog = true
    }
}

#Preview {
    BonusAmountView(viewModel: BonusAmountViewModel(networkClient: NetworkClient(environment: .staging), initiative: Initiative.mocked))
}
