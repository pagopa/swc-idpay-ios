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
    var length: Int = 6
    
    var body: some View {
        
        VStack {
            Text("Inserisci il codice ID Pay")
                .font(.PAFont.h6)
                .padding(.bottom, Constants.largeSpacing)

            HStack(spacing: Constants.smallSpacing) {
                ForEach(0..<length, id:\.self) { n in
                    PinDot(filled: Binding<Bool> (
                        get: { viewModel.pinString.count > n },
                        set: { _ in }
                    ))
                }
            }
            
            Spacer()
            pinView
        }
        .padding(Constants.mediumSpacing)
        .transactionToolbar(viewModel: viewModel, showBack: false)
        .dialog(dialogModel: buildResultModel(viewModel: viewModel, router: router, onConfirmDelete: {
            Task { @MainActor in
                router.popToRoot()
            }
        }), isPresenting: $viewModel.showErrorDialog)
        .showLoadingView(message: $viewModel.loadingStateMessage, isLoading: $viewModel.isLoading)

    }
    
    @ViewBuilder
    private var pinView: some View {
        Spacer()
        NumberPad(.pin, string: $viewModel.pinString, pinLength: length)
        Spacer()
        CustomLoadingButton(
            buttonType: .primary,
            isLoading: $viewModel.isLoading) {
                #if DEBUG
                print("PIN: \(viewModel.pinString)")
                #endif
                Task {
                    if try await viewModel.authorizeTransaction() {
                        await MainActor.run {
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
                                            router.pushTo(.receipt(receiptModel: ReceiptPdfModel(initiative: viewModel.initiative, transaction: viewModel.transaction), networkClient: viewModel.networkClient))
                                        }
                                    )]
                            )))
                        }
                    }
                }
            } label: {
                Text("Conferma")
            }
            .disabled(viewModel.pinString.count < length)
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
    HStack {
        PinDot(filled: .constant(true))
        PinDot(filled: .constant(true))
        PinDot(filled: .constant(false))
        PinDot(filled: .constant(false))
        PinDot(filled: .constant(false))
    }
}

#Preview {
    CIEPinView(viewModel: CIEPinViewModel(networkClient: NetworkClient(environment: .development), initiative: Initiative.mocked, transaction: TransactionModel.mockedSuccessTransaction, verifyCIEResponse: VerifyCIEResponse.mocked))
}
