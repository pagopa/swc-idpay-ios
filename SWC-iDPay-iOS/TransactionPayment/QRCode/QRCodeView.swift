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
    @State var showQRDialog: Bool = false
    
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
            .showLoadingView(message: $viewModel.loadingStateMessage, isLoading: $viewModel.isLoading)
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

#Preview {
    QRCodeView(viewModel: QRCodeViewModel(
        networkClient: MockedNetworkClient(),
        transactionData: CreateTransactionResponse.mockedCreated))
    .environmentObject(Router())
}
