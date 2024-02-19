//
//  TransactionDetailViewModel.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 15/02/24.
//

import Foundation
import Combine

enum TransactionDetailState {
    case noMessage
    case confirmDelete
    case genericError
    case transactionDeleted
}

@MainActor
class TransactionDetailViewModel: BaseVM {

    @Published private(set) var dialogState: TransactionDetailState = .noMessage
    @Published var isLoading: Bool = false
    @Published var loadingStateMessage: String = ""
    @Published var showErrorDialog: Bool = false
    private var cancellables = Set<AnyCancellable>()

    var transaction: TransactionModel
    var initiative: Initiative
    var verifyCIEResponse: VerifyCIEResponse

    init(networkClient: Requestable, transaction: TransactionModel, initiative: Initiative, verifyCIEResponse: VerifyCIEResponse) {
        self.transaction = transaction
        self.initiative = initiative
        self.verifyCIEResponse = verifyCIEResponse
            
        super.init(networkClient: networkClient)
        
        $dialogState
            .receive(on: DispatchQueue.main)
            .map { $0 != .noMessage }
            .assign(to: \.showErrorDialog, on: self)
            .store(in: &cancellables)
    }
    
    func confirmTransactionDelete() {
        dialogState = .confirmDelete
    }
    
    func dismissDialog() {
        dialogState = .noMessage
    }

    @discardableResult func deleteTransaction() async throws -> Bool {
        do {
            loadingStateMessage = "Annullamento della transazione in corso.."
            self.isLoading = true
            let transactionDeleted = try await networkClient.deleteTransaction(milTransactionId: transaction.transactionID)
            self.isLoading = false
            dialogState = .transactionDeleted
            return transactionDeleted
        } catch {
            self.isLoading = false
            dialogState = .genericError
            throw error
        }
    }
    
    func createTransaction() async throws -> CreateTransactionResponse {
        loadingStateMessage = "Aspetta qualche istante.."
        self.isLoading = true
        let transactionData = try await networkClient.createTransaction(initiativeId: initiative.id, amount: transaction.goodsCost)
        self.isLoading = false
        return transactionData
    }
}
