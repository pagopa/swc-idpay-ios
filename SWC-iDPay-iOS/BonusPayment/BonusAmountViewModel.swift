//
//  BonusAmountViewModel.swift
//  SWC-iDPay-iOS
//
//  Created by Pier Domenico Bonamassa on 09/02/24.
//

import Foundation
import CIEScanner


class BonusAmountViewModel: BaseVM {
    
    @Published var isLoading: Bool = false
    @Published var amountText: String = "0,00"
    @Published var loadingStateMessage: String = ""

    var reader = CIEReader(readCardMessage: "Appoggia la CIE sul dispositivo, in alto", confirmCardReadMessage: "Lettura completata")
    var initiative: Initiative
    
    init(networkClient: Requestable, initiative: Initiative) {
        self.initiative = initiative
        super.init(networkClient: networkClient)
    }
    
    func authorizeTransaction() {
        isLoading = true
        
        
        isLoading = false
    }
        
    func createTransaction() async throws {
        isLoading = true
        let response = try await networkClient.createTransaction(initiativeId: initiative.id, amount: Int(amountText.replacingOccurrences(of: ",", with: ""))!)
        isLoading = false
    }
    
    func verifyCIE(nisAuthenticated: NisAuthenticated) async throws {
        isLoading = true
        loadingStateMessage = "Stiamo verificando la CIE"
        try? await Task.sleep(nanoseconds: 1 * 2_000_000_000)
        isLoading = false
    }
    
    func authorizeTransaction() async throws {
        isLoading = true
        loadingStateMessage = "Stiamo verificando il tuo portafoglio ID Pay"
        try? await Task.sleep(nanoseconds: 1 * 2_000_000_000)
        isLoading = false
    }
}
