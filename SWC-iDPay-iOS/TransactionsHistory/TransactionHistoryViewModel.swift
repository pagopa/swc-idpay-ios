//
//  TransactionHistoryViewModel.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 13/02/24.
//

import Foundation

@MainActor
class TransactionHistoryViewModel: BaseVM {
    
    @Published var isLoading: Bool = false
    @Published var showErrorDialog: Bool = false
    @Published var loadingStateMessage: String = "Aspetta qualche istante"
    @Published var transactionHistoryList: [TransactionModel] = []
    
    func getTransactionHistory() {
        Task {
            isLoading = true
            do {
                transactionHistoryList = try await networkClient.transactionHistory()
                isLoading = false
            } catch {
                isLoading = false
            }
        }
    }
}
