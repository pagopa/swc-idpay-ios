//
//  View+Extensions.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 08/03/24.
//

import SwiftUI
import PagoPAUIKit

extension View {
    
    func buildGenericErrorResultModel(onDismiss: @escaping () -> Void) -> ResultModel {
        ResultModel(
            title: "Si è verificato un errore imprevisto",
            subtitle: "Per assistenza visita il sito pagopa.gov.it/assistenza oppure chiama il numero 06.4520.2323.",
            themeType: .error,
            buttons: [
                ButtonModel(type: .primary, themeType: .error, title: "Ok, ho capito", action: onDismiss)
            ])
    }
    
    func repeatTransactionCreate(viewModel: TransactionDeleteVM, router: Router) {
        Task {
            // Repeat createTransaction and go to verifyCIE
            let createTransactionResponse = try await viewModel.createTransaction()
            await MainActor.run {
                router.pop(to: .initiatives(viewModel: InitiativesViewModel(networkClient: viewModel.networkClient)))
                router.pushTo(
                    .cieAuth(
                        viewModel: CIEAuthViewModel(
                            networkClient: viewModel.networkClient,
                            transactionData: createTransactionResponse,
                            initiative: viewModel.initiative
                        )))
            }
        }
    }
}
