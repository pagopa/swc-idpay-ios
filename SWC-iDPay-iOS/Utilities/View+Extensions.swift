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
                let isCieAuth = router.navigationPath.contains(where: { $0.body is CIEAuthView })
                router.pop(to:.bonusAmount(
                    viewModel: BonusAmountViewModel(
                        networkClient: viewModel.networkClient,
                        initiative: viewModel.initiative!)
                ))

                if isCieAuth {
                    router.pushTo(
                        .cieAuth(
                            viewModel: CIEAuthViewModel(
                                networkClient: viewModel.networkClient,
                                transactionData: createTransactionResponse,
                                initiative: viewModel.initiative
                            )))
                } else {
                    router.pushTo(.qrCodeAuth(
                        viewModel: QRCodeViewModel(
                            networkClient: viewModel.networkClient,
                            transactionData: createTransactionResponse,
                            initiative: viewModel.initiative)
                    ))
                }
            }
        }
    }
    
    @MainActor
    func sessionExpiredDialogModel(appManager: AppStateManager, router: Router, onDismiss: (() -> Void)? = nil) -> ResultModel {
        ResultModel(
            title: "Sessione scaduta",
            subtitle: "Accedi nuovamente all'app.",
            themeType: .warning,
            buttons: [
                ButtonModel(
                    type: .primary,
                    themeType: .warning,
                    title: "Accedi",
                    action: {
                        DialogManager.shared.dismiss {
                            router.popToRoot()
                            appManager.logout()
                            onDismiss?()
                        }
                    })
            ])
    }

}
