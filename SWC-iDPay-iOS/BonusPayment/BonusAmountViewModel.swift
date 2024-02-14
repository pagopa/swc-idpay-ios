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
    
    var nisAuthenticated: NisAuthenticated?
    var transactionData: CreateTransactionResponse?
    var verifyCieData: VerifyCIEResponse?
    
    init(networkClient: Requestable, initiative: Initiative) {
        self.initiative = initiative
        super.init(networkClient: networkClient)
    }
    
    func readCIE() async throws {
        guard let challenge = transactionData?.challenge else {
            return
        }
        
        nisAuthenticated = try await reader.scan(challenge: challenge)
    }
    
    func authorizeTransaction() {
        isLoading = true
        
        
        isLoading = false
    }
        
    func createTransaction() async throws {
        isLoading = true
        transactionData = try await networkClient.createTransaction(initiativeId: initiative.id, amount: Int(amountText.replacingOccurrences(of: ",", with: ""))!)
        isLoading = false
    }
    
    func verifyCIE() async throws {
        guard let nisAuthenticated = nisAuthenticated else {
            // TODO: Manage error
            return
        }
        isLoading = true
        loadingStateMessage = "Stiamo verificando la CIE"
        guard let milTransactionId = transactionData?.milTransactionId else {
            return
        }
        verifyCieData = try await networkClient.verifyCIE(milTransactionId: milTransactionId, nis: nisAuthenticated.nis, ciePublicKey: nisAuthenticated.kpubIntServ, signature: nisAuthenticated.challengeSigned, sod: nisAuthenticated.sod)
        try? await Task.sleep(nanoseconds: 1 * 2_000_000_000)
        isLoading = false
    }
    
    func pollTransactionStatus() {
        
    }
    
    func authorizeTransaction() async throws {
        isLoading = true
        loadingStateMessage = "Stiamo verificando il tuo portafoglio ID Pay"
        try? await Task.sleep(nanoseconds: 1 * 2_000_000_000)
        isLoading = false
    }
}
