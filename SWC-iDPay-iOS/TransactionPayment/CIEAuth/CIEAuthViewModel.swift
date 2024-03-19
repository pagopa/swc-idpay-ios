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

    var reader: CIEReadable = CIEReader(readCardMessage: "Appoggia la CIE sul dispositivo, in alto", confirmCardReadMessage: "Lettura completata", logMode: .enabled)
    var nisAuthenticated: NisAuthenticated?
    
    var transactionData: CreateTransactionResponse
    
    init(networkClient: Requestable, transactionData: CreateTransactionResponse, initiative: Initiative? = nil) {
        self.transactionData = transactionData

        #if DEBUG
        if UITestingHelper.isUITesting {
            reader = MockedCIEReader()
        }
        #endif
        
        super.init(networkClient: networkClient, transactionID: self.transactionData.milTransactionId, goodsCost: self.transactionData.goodsCost, initiative: initiative)
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
            return try await networkClient.verifyCIE(milTransactionId: transactionData.milTransactionId, nis: nisAuthenticated.nis, ciePublicKey: nisAuthenticated.kpubIntServ, signature: nisAuthenticated.challengeSigned, sod: nisAuthenticated.sod)
        } catch {
            isLoading = false
            throw error
        }
    }
    
    func pollTransactionStatus(retries: Int? = nil) async throws -> TransactionModel {

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
            throw HTTPResponseError.maxRetriesExceeded
        }
        
        guard let retryAfter = transactionData.retryAfter else {
            self.isLoading = false
            throw CIEAuthError.walletVerifyError
        }

        let transaction = try await networkClient.verifyTransactionStatus(milTransactionId: transactionData.milTransactionId)

        switch transaction.status {
        case .created:
            maxRetries -= 1
            try await Task.sleep(nanoseconds: UInt64(retryAfter * 1_000_000_000))
            return try await pollTransactionStatus(retries: maxRetries)
        default:
            self.isLoading = false
            guard let coveredAmount = transaction.coveredAmount, coveredAmount > 0 else {
                throw HTTPResponseError.coveredAmountInconsistent
            }
            return transaction
        }
    }
    
}
