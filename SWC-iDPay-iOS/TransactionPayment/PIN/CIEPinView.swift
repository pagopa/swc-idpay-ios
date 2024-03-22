//
//  CIEPinView.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 22/01/24.
//

import SwiftUI
import PagoPAUIKit

struct CIEPinView: View, TransactionPaymentDeletableView {
    
    @EnvironmentObject var router: Router
    @ObservedObject var viewModel: CIEPinViewModel
    var minLength: Int = 4
    
    var body: some View {
        
        VStack {
            Text("Inserisci il codice ID Pay")
                .font(.PAFont.h6)
                .padding(.bottom, Constants.largeSpacing)

            HStack(spacing: Constants.smallSpacing) {
                if viewModel.pinString.count > 0 {
                    ForEach(0..<viewModel.pinString.count, id: \.self) { _ in
                        PinDot(filled: Binding<Bool>(
                            get: { true },
                            set: { _ in }
                        ))
                    }
                }
            }.frame(height: Constants.smallSpacing)
            
            Spacer()
            pinView
        }
        .padding(Constants.mediumSpacing)
        .transactionToolbar(viewModel: viewModel, showBack: false)
        .dialog(dialogModel: buildDeleteDialog(viewModel: viewModel, router: router, onConfirmDelete: {
            Task { @MainActor in
                router.popToRoot()
            }
        }), isPresenting: $viewModel.showDeleteDialog)
        .dialog(dialogModel: wrongPINCredentialsResultModel, isPresenting: $viewModel.showAuthDialog)
        .showLoadingView(message: $viewModel.loadingStateMessage, isLoading: $viewModel.isLoading)

    }
    
    @ViewBuilder
    private var pinView: some View {
        Spacer()
        NumberPad(.pin, string: $viewModel.pinString)
        Spacer()
        CustomLoadingButton(
            buttonType: .primary,
            isLoading: $viewModel.isLoading) {
                #if DEBUG
                print("PIN: \(viewModel.pinString)")
                #endif
                Task {
                    do {
                        try await viewModel.authorizeTransaction()
                        showPaymentConfirm()
                    } catch {
                        switch error {
                        case HTTPResponseError.invalidCode:
                            guard viewModel.pinRetries == 0 else { return }
                            showMaxPINRetries()
                        default:
                            showPaymentFailed()
                        }
                    }
                }
            } label: {
                Text("Conferma")
            }
            .disabled(viewModel.pinString.count < minLength)
    }
    
    /// Result model to populate wrong PIN dialog
    private var wrongPINCredentialsResultModel: ResultModel  {
        ResultModel(
            title: "Codice errato!",
            subtitle: "Hai a disposizione ancora \(viewModel.pinRetries) \(viewModel.pinRetries == 1 ? "tentativo" : "tentativi").",
            themeType: ThemeType.warning,
            buttons:[
                ButtonModel(
                    type: .primary,
                    themeType: .warning,
                    title: "Riprova",
                    action: {
                        viewModel.dismissDialog()
                    }
                ),
                ButtonModel(
                    type: .plain,
                    themeType: .warning,
                    title: "Esci dal pagamento",
                    action: {
                        Task {
                            try await viewModel.deleteTransaction()
                            router.popToRoot()
                        }
                    }
                )
            ])
    }
    
}

extension CIEPinView {
    // MARK: Show Thankyou page (TYP) depending on authorize response
    /// Payment confirmation TYP and redirects to Receipt
    private func showPaymentConfirm() {
        router.pushTo(.thankyouPage(result: ResultModel(
            title: "Hai pagato \(viewModel.goodsCost.formattedCurrency)!",
            themeType: .success,
            buttons: [
                ButtonModel(
                    type: .primary,
                    themeType: .success,
                    title: "Continua",
                    icon: .arrowRight,
                    action: {
                        router.pushTo(.receipt(receiptModel: ReceiptPdfModel(transaction: viewModel.transaction, initiative: viewModel.initiative), networkClient: viewModel.networkClient))
                    }
                )]
        )))
    }
    /// Generic payment error TYP. Triggered on every error returned from authorization endpoint which is not an invalidCode error.
    private func showPaymentFailed() {
        router.pushTo(.thankyouPage(result: ResultModel(
            title: "Autorizzazione negata",
            subtitle: "Non è stato addebitato alcun importo",
            themeType: .warning,
            buttons: [
                ButtonModel(
                    type: .primary,
                    themeType: .warning,
                    title: "Accetta nuovo bonus",
                    action: {
                        router.pop(to: .initiatives(viewModel: InitiativesViewModel(networkClient: viewModel.networkClient)))
                    }
                )
            ]
        )))
    }
    /// Max PIN retries exceeded TYP. On Retry pops back to PIN view and restores PIN retries.
    private func showMaxPINRetries() {
        router.pushTo(.thankyouPage(result: ResultModel(
            title: "Hai esaurito i tentativi",
            subtitle: """
                Se non ricordi il codice ID Pay,
                puoi impostarne uno nuovo sull’app IO
                nella sezione Profilo > Sicurezza.
                """,
            themeType: .warning,
            buttons: [
                ButtonModel(
                    type: .primary,
                    themeType: .warning,
                    title: "Accetta nuovo bonus",
                    action: {
                        Task {
                            try await viewModel.deleteTransaction()
                            await MainActor.run {
                                router.pop(to: .initiatives(viewModel: InitiativesViewModel(networkClient: viewModel.networkClient)))
                            }
                        }
                    }
                )]
        )))
    }
}

private struct PinDot: View {
    
    @Binding var filled: Bool
    
    var body: some View {
        Circle()
            .stroke(filled ? Color.clear : Color.paPrimary, lineWidth: 2.0 * Constants.scaleFactor)
            .background(dotBackground)
            .frame(width: Constants.pinDotSize)
    }
    
    @ViewBuilder
    var dotBackground: some View {
        if filled == true {
            Circle().fill(Color.paPrimary)
        } else {
            EmptyView()
        }
    }
}

#Preview {
    CIEPinView(viewModel: CIEPinViewModel(networkClient: NetworkClient(environment: .development), transaction: TransactionModel.mockedSuccessTransaction, verifyCIEResponse: VerifyCIEResponse.mockedSuccessResponse, initiative: Initiative.mocked))
            .environmentObject(Router())
}
