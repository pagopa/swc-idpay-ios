//
//  BonusAmountViewModel.swift
//  SWC-iDPay-iOS
//
//  Created by Pier Domenico Bonamassa on 09/02/24.
//

import Foundation
import CIEScanner

enum CIEAuthErrorType {
    case warning
    case error
    case info
}

enum CIEAuthError: Error {
    case expired
    case stolen
    case generic
    case invalidData
    case walletVerifyError
    
    var type: CIEAuthErrorType {
        switch self {
        case .generic:
            return .error
        case .walletVerifyError:
            return .info
        default:
            return .warning
        }
    }
}

@MainActor
class BonusAmountViewModel: BaseVM {
    
    @Published var isLoading: Bool = false
    @Published var amountText: String = "0,00"
    @Published var loadingStateMessage: String = ""
    @Published var cieAuthError: CIEAuthError?

    var reader = CIEReader(readCardMessage: "Appoggia la CIE sul dispositivo, in alto", confirmCardReadMessage: "Lettura completata")
    var initiative: Initiative
    
    var nisAuthenticated: NisAuthenticated?
    var transactionData: CreateTransactionResponse?
    
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
    
    func verifyCIE() async throws -> VerifyCIEResponse {
        guard let nisAuthenticated = nisAuthenticated else {
            isLoading = false
            throw CIEAuthError.invalidData
        }
        isLoading = true
        loadingStateMessage = "Stiamo verificando la CIE"
        guard let milTransactionId = transactionData?.milTransactionId else {
            isLoading = false
            throw CIEAuthError.invalidData
        }
        
        isLoading = false
        return try await networkClient.verifyCIE(milTransactionId: milTransactionId, nis: nisAuthenticated.nis, ciePublicKey: nisAuthenticated.kpubIntServ, signature: nisAuthenticated.challengeSigned, sod: nisAuthenticated.sod)
    }
    
    func pollTransactionStatus(retries: Int? = nil) async throws -> TransactionModel? {

        loadingStateMessage = "Stiamo verificando il tuo portafoglio ID Pay"
        self.isLoading = true
        var maxRetries: Int
        
        if retries != nil {
            maxRetries = retries!
        } else {
            guard var transactionRetries = transactionData?.maxRetries else {
                self.isLoading = false
                throw CIEAuthError.walletVerifyError
            }
            maxRetries = transactionRetries
        }
        
        guard maxRetries > 0 else {
            self.isLoading = false
            throw CIEAuthError.walletVerifyError
        }
        
        guard let retryAfter = transactionData?.retryAfter, let transactionId = transactionData?.milTransactionId else {
            self.isLoading = false
            throw CIEAuthError.walletVerifyError
        }

        let transaction = try await networkClient.verifyTransactionStatus(milTransactionId: transactionId)

        if transaction.status == .created {
            maxRetries -= 1
            try await Task.sleep(nanoseconds: UInt64(retryAfter * 1_000_000_000))
            return try await pollTransactionStatus(retries: maxRetries)
        } else {
            self.isLoading = false
            return transaction
        }
        
    }
    
    func authorizeTransaction() async throws {
        isLoading = true
        loadingStateMessage = "Stiamo verificando il tuo portafoglio ID Pay"
        try? await Task.sleep(nanoseconds: 1 * 2_000_000_000)
        isLoading = false
    }
}
