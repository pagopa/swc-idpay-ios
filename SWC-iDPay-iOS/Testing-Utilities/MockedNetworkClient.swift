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
        if let refreshTokenSuccess = ProcessInfo.processInfo.environment["-refresh-token-success"], refreshTokenSuccess == "0" {
            throw HTTPResponseError.genericError
        }
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
        try? await Task.sleep(nanoseconds: 1 * 1_000_000_000)

        if let mockFileName = ProcessInfo.processInfo.environment["-mock-filename"] {
            do {
                let initiativesResponse: InitiativesResponse = try UITestingHelper.getMockedObject(jsonName: mockFileName)!
                return initiativesResponse.initiatives
            } catch {
                return []
            }
        }
        return []
    }
    
    func createTransaction(initiativeId: String, amount: Int) async throws -> CreateTransactionResponse {
        if UITestingHelper.containsInputOption("-qrcode-load-home") {
            // Has 10 retries to ensure we can tap home button while loading
            return CreateTransactionResponse.mockedCreatedHighRetries
        } else {
            return CreateTransactionResponse.mockedCreated
        }
    }
    
    func verifyCIE(milTransactionId: String, nis: String, ciePublicKey: String, signature: String, sod: String) async throws -> VerifyCIEResponse {
        try? await Task.sleep(nanoseconds: 1 * 1_000_000_000)
        if let cieReadingSuccess = ProcessInfo.processInfo.environment["-cie-reading-success"], cieReadingSuccess == "0" {
            throw CIEAuthError.walletVerifyError
        }
        return VerifyCIEResponse.mockedSuccessResponse
    }
    
    func verifyTransactionStatus(milTransactionId: String) async throws -> TransactionModel {

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
        try? await Task.sleep(nanoseconds: 1 * 1_000_000_000)
        if UITestingHelper.containsInputOption("-auth-error") {
            throw HTTPResponseError.invalidCode
        } else if UITestingHelper.containsInputOption("-transaction-generic-error") {
            throw HTTPResponseError.genericError
        }
        
        return
    }
    
    func deleteTransaction(milTransactionId: String) async throws -> Bool {
        try? await Task.sleep(nanoseconds: 1 * 1_000_000_000)
        if let transactionDeleteSuccess = ProcessInfo.processInfo.environment["-transaction-delete-success"] {
            if transactionDeleteSuccess == "0" {
                throw HTTPResponseError.genericError
            }
        }
        return true
    }
    
    func transactionHistory() async throws -> [TransactionModel] {
        print("Delay transaction history loading")
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
            return TransactionModel.randomTransactionsList
        }
    }
    
}
#endif
