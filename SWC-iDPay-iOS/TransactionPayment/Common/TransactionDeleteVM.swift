//
//  TransactionDeleteVM.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 20/02/24.
//
import Foundation
import Combine

enum TransactionDeleteState {
    case noMessage
    case confirmDelete
    case confirmDeleteHistory
    case genericError
}

@MainActor
class TransactionDeleteVM: BaseVM {

    @Published private(set) var deleteDialogState: TransactionDeleteState = .noMessage
    @Published var isLoading: Bool = false
    @Published var loadingStateMessage: String = ""
    @Published var showDeleteDialog: Bool = false

    private var cancellables = Set<AnyCancellable>()

    var transactionID: String
    var goodsCost: Int
    var initiative: Initiative?

    init(networkClient: Requestable, transactionID: String, goodsCost: Int, initiative: Initiative? = nil) {
        self.transactionID = transactionID
        self.goodsCost = goodsCost
        self.initiative = initiative
            
        super.init(networkClient: networkClient)
        
        $deleteDialogState
            .receive(on: DispatchQueue.main)
            .map { $0 != .noMessage }
            .assign(to: \.showDeleteDialog, on: self)
            .store(in: &cancellables)
    }

    
    func confirmTransactionDelete() {
        deleteDialogState = .confirmDelete
    }
    
    func confirmHistoryTransactionDelete() {
        deleteDialogState = .confirmDeleteHistory
    }
    
    func dismissDeleteDialog() {
        deleteDialogState = .noMessage
    }

    @discardableResult func deleteTransaction(loadingMessage: String = "Annullamento della transazione in corso..") async throws -> Bool {
        do {
            loadingStateMessage = loadingMessage
            self.isLoading = true
            let transactionDeleted = try await networkClient.deleteTransaction(milTransactionId: transactionID)
            self.isLoading = false
            deleteDialogState = .noMessage
            return transactionDeleted
        } catch {
            showError()
            throw error
        }
    }
    
    func createTransaction() async throws -> CreateTransactionResponse {
        do {
            loadingStateMessage = "Aspetta qualche istante"
            self.isLoading = true
            guard let initiativeID = initiative?.id else {
                showError()
                throw HTTPResponseError.networkError("No initiative provided")
            }
            let transactionData = try await networkClient.createTransaction(initiativeId: initiativeID, amount: goodsCost)
            self.isLoading = false
            return transactionData
        }  catch {
            showError()
            throw error
        }
    }

    func showError() {
        self.isLoading = false
        deleteDialogState = .genericError
    }
}
