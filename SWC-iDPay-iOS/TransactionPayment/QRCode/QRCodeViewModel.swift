//
//  QRCodeViewModel.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 22/03/24.
//

import Foundation

enum QRCodePollingStatus {
    case initiated
    case identified
    case authorized
    case canceled
    case rejected
}

class QRCodeViewModel: TransactionDeleteVM {
    
    @Published var qrCodePollingStatus: QRCodePollingStatus = .initiated
    @Published var transaction: TransactionModel?
    
    private var tempTransactionStatus: TransactionStatus = .created
    private var shouldPollTransactionStatus: Bool = true
    var transactionData: CreateTransactionResponse
    
    init(networkClient: Requestable, transactionData: CreateTransactionResponse, initiative: Initiative? = nil) {
        self.transactionData = transactionData
        
        super.init(networkClient: networkClient, transactionID: self.transactionData.milTransactionId, goodsCost: self.transactionData.goodsCost, initiative: initiative)
    }
 
    func pollTransactionStatus(retries: Int? = nil) async throws {
        
        guard shouldPollTransactionStatus else { return }
        var maxRetries: Int = retries ?? transactionData.maxRetries ?? 10
        
        guard maxRetries > 0 else {
            throw HTTPResponseError.maxRetriesExceeded
        }
        
        var retryAfter = transactionData.retryAfter ?? 5
        
        transaction = try await networkClient.verifyTransactionStatus(milTransactionId: transactionData.milTransactionId)
        
        guard shouldPollTransactionStatus == true else {
            return
        }
        
        guard let transaction else {
            maxRetries -= 1
            try await Task.sleep(nanoseconds: UInt64(retryAfter * 1_000_000_000))
            return try await pollTransactionStatus(retries: maxRetries)
        }
        
        switch (tempTransactionStatus, transaction.status) {
        case (.created, .identified):
            // Mostra waitingView "Attendi autorizzazione"
            tempTransactionStatus = transaction.status
            qrCodePollingStatus = .identified
        case (.identified, .authorized),
            (.created, .authorized):
            // Mostra TYP "Hai pagato"
            qrCodePollingStatus = .authorized
            return
        case (.identified, .created):
            // Mostra TYP warning: "L'operazione è stata annullata"
            qrCodePollingStatus = .canceled
            return
        case (.identified, .rejected),
            (.created, .rejected):
            // Mostra TYP warning: "Autorizzazione negata"
            qrCodePollingStatus = .rejected
            return
        default:
            break
        }
        
        maxRetries -= 1
        try await Task.sleep(nanoseconds: UInt64(retryAfter * 1_000_000_000))
        return try await pollTransactionStatus(retries: maxRetries)
    }
    
    func stopPolling() {
        shouldPollTransactionStatus = false
    }

    func checkTransactionStatus() async throws -> TransactionStatus {
        transaction = try await networkClient.verifyTransactionStatus(milTransactionId: transactionData.milTransactionId)
        guard let transaction else {
            throw HTTPResponseError.genericError
        }
        return transaction.status
    }
    
    func setCancelledStatus() {
        guard transaction != nil else { return }
        transaction!.status = .cancelled
    }
}
