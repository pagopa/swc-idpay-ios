//
//  TransactionPaymentDeletableView.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 20/02/24.
//

import SwiftUI
import PagoPAUIKit

protocol TransactionPaymentDeletableView where Self:View {
    
    func buildDeleteDialog(viewModel: TransactionDeleteVM, router: Router, onConfirmDelete: @escaping () -> Void, onRetry: (() -> Void)?) -> ResultModel
}

extension TransactionPaymentDeletableView {
    
    @MainActor
    func buildDeleteDialog(viewModel: TransactionDeleteVM, router: Router, onConfirmDelete: @escaping () -> Void, onRetry: (() -> Void)? = nil) -> ResultModel {
        switch viewModel.deleteDialogState {
        case .genericError:
            return buildGenericErrorResultModel {
                viewModel.dismissDeleteDialog()
            }
        case .confirmDelete:
            return ResultModel(
                title: "Vuoi uscire dall’operazione in corso?",
                subtitle: "L’operazione verrà annullata e sarà necessario ricominciare da capo.",
                themeType: .light,
                buttons: [
                    ButtonModel(type: .primary, themeType: .light, title: "Annulla", action: {
                        viewModel.dismissDeleteDialog()
                    }),
                    ButtonModel(type: .plain, themeType: .light, title: "Esci dal pagamento", action: {
                        viewModel.dismissDeleteDialog()
                        Task {
                            try await viewModel.deleteTransaction()
                            onConfirmDelete()
                        }
                    })
                ])
        case .confirmDeleteHistory:
            return ResultModel(
                title: "Vuoi annullare la spesa del bonus ID Pay?",
                subtitle: "Se annulli l’operazione,l’importo verrà riaccreditato sull’iniziativa del cittadino.",
                themeType: .light,
                buttons: [
                    ButtonModel(type: .primary, themeType: .light, title: "Torna indietro", action: {
                        viewModel.dismissDeleteDialog()
                    }),
                    ButtonModel(type: .plain, themeType: .light, title: "Annulla operazione", action: {
                        viewModel.dismissDeleteDialog()
                        Task {
                            try await viewModel.deleteTransaction()
                            onConfirmDelete()
                        }
                    })
                ])
        case .noMessage:
            return ResultModel.emptyModel
        }

    }
}
