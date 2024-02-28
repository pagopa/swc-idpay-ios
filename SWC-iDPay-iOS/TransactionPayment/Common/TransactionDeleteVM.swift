//
//  TransactionDeleteVM.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 20/02/24.
//
import Foundation
import Combine

@MainActor
class TransactionDeleteVM: BaseVM {

    @Published private(set) var dialogState: TransactionDetailState = .noMessage
    @Published var isLoading: Bool = false
    @Published var loadingStateMessage: String = ""
    @Published var showErrorDialog: Bool = false

    private var cancellables = Set<AnyCancellable>()

    var transactionID: String
    var goodsCost: Int
    var initiative: Initiative?

    init(networkClient: Requestable, transactionID: String, goodsCost: Int, initiative: Initiative? = nil) {
        self.transactionID = transactionID
        self.goodsCost = goodsCost
        self.initiative = initiative
            
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
    
    func confirmHistoryTransactionDelete() {
        dialogState = .confirmDeleteHistory
    }
    
    func dismissDialog() {
        dialogState = .noMessage
    }
    
    func showRetry() {
        dialogState = .transactionDeleted
    }

    @discardableResult func deleteTransaction() async throws -> Bool {
        do {
            loadingStateMessage = "Annullamento della transazione in corso.."
            self.isLoading = true
            let transactionDeleted = try await networkClient.deleteTransaction(milTransactionId: transactionID)
            self.isLoading = false
            dialogState = .noMessage
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
        dialogState = .genericError
    }
}
