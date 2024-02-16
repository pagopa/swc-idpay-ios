//
//  DeleteTransactionDialog.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 16/02/24.
//

import SwiftUI
import PagoPAUIKit

struct DeleteTransactionDialog<Content: View>: View {
    
    @Binding var isPresentingDialog: Bool
    @State var isPresentingError: Bool = false
    @State var isDeletingTransaction: Bool = false

    private var content: Content
    private var transactionId: String
    private var networkClient: Requestable
    private var onDeleted: () -> Void
    
    init(present: Binding<Bool>, transactionId: String, networkClient: Requestable, onDeleted: @escaping () -> Void, content: Content){
        self._isPresentingDialog = present
        self.transactionId = transactionId
        self.networkClient = networkClient
        self.onDeleted = onDeleted
        self.content = content
    }
    
    var body: some View {
        content
            .dialog(dialogModel: 
                        ResultModel(
                            title: "Vuoi uscire dall’operazione in corso?",
                            subtitle: "L’operazione verrà annullata e sarà necessario ricominciare da capo.",
                            themeType: .light,
                        buttons: [
                            ButtonModel(type: .primary, themeType: .light, title: "Annulla", action: {
                                var transaction = Transaction()
                                transaction.disablesAnimations = true
                                withTransaction(transaction) {
                                    isPresentingDialog = false
                                }
                            }),
                            ButtonModel(type: .plain, themeType: .light, title: "Esci dal pagamento", action: {
                                isPresentingDialog = false
                                isDeletingTransaction = true

                                Task {
                                    do {
                                        let deleted = try await networkClient.deleteTransaction(milTransactionId: transactionId)
                                        await MainActor.run {
                                            onDeleted()
                                        }
                                    } catch {
                                        await MainActor.run {
                                            isDeletingTransaction = false
                                            isPresentingError = true
                                        }
                                    }
                                }
                            })
                        ]),
                    isPresenting: $isPresentingDialog)
            .dialog(dialogModel: 
                        ResultModel(
                            title: "Si è verificato un errore imprevisto",
                            subtitle: "Per assistenza visita il sito pagopa.gov.it/assistenza oppure chiama il numero 06.4520.2323.",
                            themeType: .light,
                            buttons: [
                                ButtonModel(type: .primary, themeType: .light, title: "Ok, ho capito", action: {
                                    isPresentingError = false
                                })
                            ]),
                    isPresenting: $isPresentingError)
            .showLoadingView(message: Binding<String> (
                get: {"Annullamento della transazione in corso.."},
                set: { _ in }
            ), isLoading: $isDeletingTransaction)
    }
}

struct DeleteTransactionModifier: ViewModifier {
    
    @Binding var isPresentingDialog: Bool
    var transactionId: String
    var networkClient: Requestable
    var onDeleted: () -> Void
    
    func body(content: Content) -> some View {
        DeleteTransactionDialog(present: $isPresentingDialog, transactionId: transactionId, networkClient: networkClient, onDeleted: onDeleted, content: content)
    }
}

extension View {
    
    func showDeleteTransactionDialog(isPresenting: Binding<Bool>, transactionId: String, networkClient: Requestable, onDeleted: @escaping () -> Void) -> some View {
        modifier(DeleteTransactionModifier(isPresentingDialog: isPresenting, transactionId: transactionId, networkClient: networkClient, onDeleted: onDeleted))
    }
}

//#Preview {
//    DeleteTransactionDialog()
//}
