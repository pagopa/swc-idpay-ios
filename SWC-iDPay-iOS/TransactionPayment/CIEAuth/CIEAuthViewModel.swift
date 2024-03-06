//
//  CIEAuthViewModel.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 15/02/24.
//

import Foundation
import CIEScanner

@MainActor
class CIEAuthViewModel: TransactionDeleteVM {
    
    @Published var cieAuthError: CIEAuthError?

    var reader = CIEReader(readCardMessage: "Appoggia la CIE sul dispositivo, in alto",
                           confirmCardReadMessage: "Lettura completata")
    var nisAuthenticated: NisAuthenticated?
    
    var transactionData: CreateTransactionResponse
    
    init(networkClient: Requestable, transactionData: CreateTransactionResponse, initiative: Initiative? = nil) {
        self.transactionData = transactionData

        super.init(networkClient: networkClient,
                   transactionID: self.transactionData.milTransactionId,
                   goodsCost: self.transactionData.goodsCost,
                   initiative: initiative)
    }

    func readCIE() async throws {
        nisAuthenticated = try await reader.scan(challenge: transactionData.challenge)
    }
    
    func verifyCIE() async throws -> VerifyCIEResponse {
        do {
            guard let nisAuthenticated = nisAuthenticated else {
                isLoading = false
                throw CIEReaderError.responseError("")
            }
            isLoading = true
            loadingStateMessage = "Stiamo verificando la CIE"
            return try await networkClient.verifyCIE(milTransactionId: transactionData.milTransactionId,
                                                     nis: nisAuthenticated.nis,
                                                     ciePublicKey: nisAuthenticated.kpubIntServ,
                                                     signature: nisAuthenticated.challengeSigned,
                                                     sod: nisAuthenticated.sod)
        } catch {
            isLoading = false
            throw error
        }
    }
    
    func pollTransactionStatus(retries: Int? = nil) async throws -> TransactionModel? {

        loadingStateMessage = "Stiamo verificando il tuo portafoglio ID Pay"
        self.isLoading = true
        var maxRetries: Int
        
        if retries != nil {
            maxRetries = retries!
        } else {
            guard let transactionRetries = transactionData.maxRetries else {
                self.isLoading = false
                throw CIEAuthError.walletVerifyError
            }
            maxRetries = transactionRetries
        }
        
        guard maxRetries > 0 else {
            self.isLoading = false
            throw CIEAuthError.walletVerifyError
        }
        
        guard let retryAfter = transactionData.retryAfter else {
            self.isLoading = false
            throw CIEAuthError.walletVerifyError
        }

        let transaction = try await networkClient.verifyTransactionStatus(milTransactionId: transactionData.milTransactionId)

        if transaction.status == .created {
            maxRetries -= 1
            try await Task.sleep(nanoseconds: UInt64(retryAfter * 1_000_000_000))
            return try await pollTransactionStatus(retries: maxRetries)
        } else {
            self.isLoading = false
            return transaction
        }
        
    }
    
}
