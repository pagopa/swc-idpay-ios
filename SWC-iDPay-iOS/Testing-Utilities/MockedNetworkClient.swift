//
//  MockedNetworkClient.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 28/02/24.
//

#if DEBUG
import Foundation

class MockedNetworkClient: Requestable {
    
    var sessionManager: SessionManager
    
    static let validTransactionID = "fakeMilValidTransactionId"
    static let errorTransactionID = "fakeMilErrorTransactionId"
    static let oldAuthorizedTransactionID = "oldAuthorizedMilTransactionId"

    private var retries: Int = 2
    
    init(sessionManager: SessionManager = SessionManager()) {
        self.sessionManager = sessionManager
    }
    
    func refreshToken() async throws {
        try? await Task.sleep(nanoseconds: 1 * 1_000_000_000)
        print("Environment:\(ProcessInfo.processInfo.environment)")
        if let refreshTokenOpt = ProcessInfo.processInfo.environment.filter({
            $0.key.contains("-refresh-token")}).first {
            if refreshTokenOpt.key == "-refresh-token-success", refreshTokenOpt.value == "1" {
                return
            }
            try await MainActor.run {
                NotificationCenter.default.post(name: .sessionExpired, object: nil)
                throw HTTPResponseError.unauthorized
            }
        }
        return
    }
    
    func login(username: String, password: String) async throws {
        try? await Task.sleep(nanoseconds: 1 * 2_000_000_000)
        if UITestingHelper.isUserLoginSuccess {
            if UITestingHelper.containsInputOption("-refresh-token-success") {
                sessionManager.logout()
            }
            return
        } else {
            throw HTTPResponseError.unauthorized
        }
    }
    
    func getInitiatives() async throws -> [Initiative] {
        try await checkSessionExpiredTesting(scope: "initiatives")

        try? await Task.sleep(nanoseconds: 1 * 1_000_000_000)
        if let mockFileName = ProcessInfo.processInfo.environment["-mock-filename"] {
            do {
                let initiativesResponse: InitiativesResponse = try UITestingHelper.getMockedObject(jsonName: mockFileName)!
                return initiativesResponse.initiatives
            } catch {
                return []
            }
        } else if let _ = ProcessInfo.processInfo.environment["-initiative-list-error"] {
            throw HTTPResponseError.genericError
        } 
        return []
    }
    
    func createTransaction(initiativeId: String, amount: Int) async throws -> CreateTransactionResponse {
        if UITestingHelper.containsInputOption("-qrcode-load-home") {
            // Has 10 retries to ensure we can tap home button while loading
            return CreateTransactionResponse.mockedCreatedHighRetries
        } else if UITestingHelper.isSessionExpiredTesting(scope: "create") {
            try await refreshToken()
        }
        return CreateTransactionResponse.mockedCreated
    }
    
    func verifyCIE(milTransactionId: String, nis: String, ciePublicKey: String, signature: String, sod: String) async throws -> VerifyCIEResponse {
        try? await Task.sleep(nanoseconds: 1 * 1_000_000_000)
        if let cieReadingSuccess = ProcessInfo.processInfo.environment["-cie-reading-success"], cieReadingSuccess == "0" {
            throw CIEAuthError.walletVerifyError
        } else if UITestingHelper.isSessionExpiredTesting(scope: "verify-cie") {
            try await refreshToken()
        }
        return VerifyCIEResponse.mockedSuccessResponse
    }
    
    func verifyTransactionStatus(milTransactionId: String) async throws -> TransactionModel {

        try await checkSessionExpiredTesting(scope: "polling")
        try? await Task.sleep(nanoseconds: 1 * 500_000_000)

        if UITestingHelper.isMaxRetriesTest {
            return TransactionModel.mockedCreatedTransaction
        }
        if UITestingHelper.containsInputOption("-residual-amount") {
            return TransactionModel.mockedResidualAmountTransaction
        }
        if UITestingHelper.containsInputOption("-qrcode-ok") {
            switch retries {
            case 2:
                retries -= 1
                return TransactionModel.mockedIdentifiedTransaction
            default:
                return TransactionModel.mockedSuccessTransaction
            }
        }
        if UITestingHelper.containsInputOption("-qrcode-help") {
            return TransactionModel.mockedCreatedTransaction
        }
        if UITestingHelper.containsInputOption("-qrcode-ok-residual-amount") {
            switch retries {
            case 2:
                retries -= 1
                return TransactionModel.mockedIdentifiedTransaction
            default:
                return TransactionModel.mockedAuthResidualAmountTransaction
            }
        }
        if UITestingHelper.containsInputOption("-qrcode-canceled") {
            switch retries {
            case 2:
                retries -= 1
                return TransactionModel.mockedIdentifiedTransaction
            default:
                return TransactionModel.mockedCreatedTransaction
            }
        }
        // Cancel authorized transaction during qrcode polling
        if UITestingHelper.containsInputOption("-qrcode-canceled-during-polling") {
            switch retries {
            case 2, 1:
                retries -= 1
                return TransactionModel.mockedIdentifiedTransaction
            default:
                return TransactionModel.mockedSuccessTransaction
            }
        }
        // Transaction rejected
        if UITestingHelper.containsInputOption("-qrcode-rejected") {
            switch retries {
            case 2:
                retries -= 1
                return TransactionModel.mockedIdentifiedTransaction
            default:
                return TransactionModel.mockedRejectedTransaction
            }
        }
        // Load home in qrcode payment
        if UITestingHelper.containsInputOption("-qrcode-load-home") {
            return TransactionModel.mockedCreatedTransaction
        }
        if UITestingHelper.containsInputOption("-qrcode-polling-error") {
            throw HTTPResponseError.genericError
        }
        
        return TransactionModel.mockedIdentifiedTransaction
    }
    
    func authorizeTransaction(milTransactionId: String, authCodeBlockData: AuthCodeData) async throws {
        try await checkSessionExpiredTesting(scope: "auth")
        try? await Task.sleep(nanoseconds: 1 * 1_000_000_000)
        if UITestingHelper.containsInputOption("-auth-error") {
            throw HTTPResponseError.invalidCode
        } else if UITestingHelper.containsInputOption("-transaction-generic-error") {
            throw HTTPResponseError.genericError
        }
        
        return
    }
    
    func deleteTransaction(milTransactionId: String) async throws -> Bool {
        try await checkSessionExpiredTesting(scope: "delete")
        try? await Task.sleep(nanoseconds: 1 * 1_000_000_000)
        if let transactionDeleteSuccess = ProcessInfo.processInfo.environment["-transaction-delete-success"] {
            if transactionDeleteSuccess == "0" {
                throw HTTPResponseError.genericError
            }
        }
        return true
    }
    
    func transactionHistory() async throws -> [TransactionModel] {
        try? await Task.sleep(nanoseconds: 1 * 2_000_000_000)
        if let mockFileName = ProcessInfo.processInfo.environment["-mock-filename"] {
            do {
                let transactionsList: TransactionHistoryResponse = try UITestingHelper.getMockedObject(jsonName: mockFileName)!
                let transactions = transactionsList.transactions
                
                return transactions.map {
                    var modifiedTransaction = $0
                    switch modifiedTransaction.milTransactionId {
                    case MockedNetworkClient.validTransactionID, MockedNetworkClient.errorTransactionID:
                        modifiedTransaction.date = Date()
                    case MockedNetworkClient.oldAuthorizedTransactionID:
                        modifiedTransaction.date = Calendar.current.date(byAdding: .day, value: -4, to: Date())
                    default:
                        modifiedTransaction.date = Date.randomUTCDate()
                    }
                    return modifiedTransaction
                }
            } catch {
                return []
            }
        } else if UITestingHelper.isEmptyStateTest {
            return []
        } else {
            try await checkSessionExpiredTesting(scope: "history")
        }
        
        return TransactionModel.randomTransactionsList
    }
    
}

extension MockedNetworkClient {
    func checkSessionExpiredTesting(scope: String) async throws {
        if UITestingHelper.isSessionExpiredTesting(scope: scope) {
            try await refreshToken()
        }
    }
}
#endif
