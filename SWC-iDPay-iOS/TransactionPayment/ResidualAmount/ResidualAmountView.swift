//
//  ResidualAmountView.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 21/03/24.
//

import SwiftUI
import PagoPAUIKit

struct ResidualAmountView: View, TransactionPaymentDeletableView {
    
    @ObservedObject var viewModel: ResidualAmountViewModel
    @EnvironmentObject var router: Router
    @State var showRetry: Bool = false

    init(viewModel: ResidualAmountViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            VStack(spacing: 0) {
                VStack {
                    VStack(alignment: .leading) {
                        Text("Pagamento residuo")
                            .font(.PAFont.h3)
                            .padding(.vertical, Constants.mediumSpacing)
                        
                        HStack {
                            Text("Importo del bene")
                                .font(.PAFont.body)
                            Spacer()
                            Text(viewModel.transaction.goodsCost.formattedCurrency)
                                .font(.PAFont.h6)
                        }
                        .padding(Constants.smallSpacing1)
                        .background {
                            RoundedRectangle(cornerRadius: Constants.xsmallSpacing)
                                .stroke(Color.grey100, lineWidth: 1.0)
                                .foregroundColor(Color.clear)
                        }
                        
                        HStack {
                            Text("BONUS ID PAY")
                                .font(.PAFont.caption)
                                .foregroundColor(.grey650)

                            Spacer()
                            Text("-\(viewModel.transaction.coveredAmount!.formattedCurrency)")
                                .font(.PAFont.h6)
                                .foregroundColor(.paBlack)

                        }
                        .padding(.vertical, Constants.smallSpacing1)
                        Divider()
                        
                    }
                    .padding([.leading, .trailing], Constants.mediumSpacing)
                    
                    HStack {
                        Text("Residuo")
                            .font(.PAFont.h3)
                        Spacer()
                        Text(viewModel.residualAmount.formattedCurrency)
                            .font(.PAFont.h1Hero)
                    }
                    .padding([.leading, .trailing], Constants.mediumSpacing)
                    .padding(.bottom, Constants.xsmallSpacing)
                }
                .background(Color.white)
                Image("ticket-final-bkg", bundle: nil)
                    .resizable(resizingMode: .tile)
                    .frame(maxWidth: .infinity, maxHeight: 23)
                    .scaledToFill()
            }
            Spacer()
            FooterButtonsView(
                buttons:
                    [ButtonModel(
                        type: .primaryBordered,
                        themeType: .light,
                        title: "Annulla operazione",
                        action: {
                            // TODO: Annullamento operazione
                        }
                    ),
                     ButtonModel(
                        type: .primary,
                        themeType: .light,
                        title: "Paga \(viewModel.residualAmount.formattedCurrency)",
                        action: {
                            router.pushTo(.cashPayment(viewModel:
                                                        CashPaymentViewModel(
                                                            networkClient: viewModel.networkClient,
                                                            transaction: viewModel.transaction)))
                        }
                     )]
            )
        }
        .background(Color.grey100)
        .residualAmountToolbar(residualAmount: viewModel.transaction.residualAmount)
        .dialog(dialogModel: buildDeleteDialog(viewModel: viewModel, router: router, onConfirmDelete: {
            guard showRetry == false else { return }
            Task { @MainActor in
                router.popToRoot()
            }
        }), isPresenting: $viewModel.showDeleteDialog)
        .showLoadingView(message: $viewModel.loadingStateMessage, isLoading: $viewModel.isLoading)
        
    }
    
}

#Preview {
    ResidualAmountView(viewModel: ResidualAmountViewModel(networkClient: MockedNetworkClient(), transaction: TransactionModel.mockedIdentifiedTransaction))
        .environmentObject(Router())
}
