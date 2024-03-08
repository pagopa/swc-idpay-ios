//
//  View+Extensions.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 08/03/24.
//

import SwiftUI

extension View {
    
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
