//
//  BonusAmountViewModel.swift
//  SWC-iDPay-iOS
//
//  Created by Pier Domenico Bonamassa on 09/02/24.
//

import Foundation
import CIEScanner

@MainActor
class BonusAmountViewModel: BaseVM {
    
    @Published var isCreatingTransaction: Bool = false
    @Published var isLoading: Bool = false
    @Published var amountText: String = "0,00"
    @Published var loadingStateMessage: String = ""

    var reader = CIEReader(readCardMessage: "Appoggia la CIE sul dispositivo, in alto", confirmCardReadMessage: "Lettura completata")
    var initiative: Initiative
    
    var nisAuthenticated: NisAuthenticated?
    var transactionData: CreateTransactionResponse?
    
    init(networkClient: Requestable, initiative: Initiative) {
        self.initiative = initiative
        super.init(networkClient: networkClient)
    }
            
    func createTransaction() async throws {
        self.isCreatingTransaction = true
        transactionData = try await networkClient.createTransaction(initiativeId: initiative.id, amount: Int(amountText.replacingOccurrences(of: ",", with: ""))!)
        self.isCreatingTransaction = false
    }
    
}
