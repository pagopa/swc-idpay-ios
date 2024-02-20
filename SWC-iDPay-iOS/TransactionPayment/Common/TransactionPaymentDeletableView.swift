//
//  TransactionPaymentDeletableView.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 20/02/24.
//

import SwiftUI
import PagoPAUIKit

protocol TransactionPaymentDeletableView where Self:View {
    
    func buildResultModel(viewModel: TransactionDeleteVM, router: Router, retryAction: @escaping () -> Void) -> ResultModel
}

extension TransactionPaymentDeletableView {
    
    @MainActor
    func buildResultModel(viewModel: TransactionDeleteVM, router: Router, retryAction: @escaping () -> Void) -> ResultModel {
        switch viewModel.dialogState {
        case .genericError:
            return ResultModel(
                title: "Si è verificato un errore imprevisto",
                subtitle: "Per assistenza visita il sito pagopa.gov.it/assistenza oppure chiama il numero 06.4520.2323.",
                themeType: .light,
                buttons: [
                    ButtonModel(type: .primary, themeType: .light, title: "Ok, ho capito", action: {
                        viewModel.dismissDialog()
                    })
                ])
        case .confirmDelete:
            return ResultModel(
                title: "Vuoi uscire dall’operazione in corso?",
                subtitle: "L’operazione verrà annullata e sarà necessario ricominciare da capo.",
                themeType: .light,
                buttons: [
                    ButtonModel(type: .primary, themeType: .light, title: "Annulla", action: {
                        viewModel.dismissDialog()
                    }),
                    ButtonModel(type: .plain, themeType: .light, title: "Esci dal pagamento", action: {
                        viewModel.dismissDialog()
                        Task {
                            try await viewModel.deleteTransaction()
                        }
                    })
                ])
        case .transactionDeleted:
            return ResultModel(
                title: "L'operazione è stata annullata",
                themeType: .light,
                buttons: [
                    ButtonModel(
                        type: .primary,
                        themeType: .light,
                        title: "Accetta nuovo bonus",
                        action: {
                            viewModel.dismissDialog()
                            router.pop(to: .initiatives(viewModel: InitiativesViewModel(networkClient: viewModel.networkClient)))
                        }),
                    ButtonModel(
                        type: .primaryBordered,
                        themeType: .light,
                        title: "Riprova",
                        action: {
                            viewModel.dismissDialog()
                            retryAction()
                        })
                ])
        case .noMessage:
            return ResultModel.emptyModel
        }

    }
}
