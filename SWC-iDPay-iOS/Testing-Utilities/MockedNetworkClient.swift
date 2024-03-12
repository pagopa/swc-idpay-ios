//
//  MockedNetworkClient.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 28/02/24.
//

import Foundation

class MockedNetworkClient: Requestable {
    
    var sessionManager: SessionManager
    
    static let validTransactionID = "fakeMilValidTransactionId"
    static let errorTransactionID = "fakeMilErrorTransactionId"
    static let oldAuthorizedTransactionID = "oldAuthorizedMilTransactionId"

    init(sessionManager: SessionManager = SessionManager()) {
        self.sessionManager = sessionManager
    }
    
    func refreshToken() async throws {
        
    }
    
    func login(username: String, password: String) async throws {
        print("Wait to login")
        try? await Task.sleep(nanoseconds: 1 * 2_000_000_000)
        if UITestingHelper.isUserLoginSuccess {
            return
        } else {
            throw HTTPResponseError.unauthorized
        }
    }
    
    func getInitiatives() async throws -> [Initiative] {
        try? await Task.sleep(nanoseconds: 1 * 2_000_000_000)

        if let mockFileName = ProcessInfo.processInfo.environment["-mock-filename"] {
            do {
                var initiativesResponse: InitiativesResponse = try UITestingHelper.getMockedObject(jsonName: mockFileName)!
                return initiativesResponse.initiatives
            } catch {
                return []
            }
        }
        return []
    }
    
    func createTransaction(initiativeId: String, amount: Int) async throws -> CreateTransactionResponse {
        CreateTransactionResponse.mockedCreated
    }
    
    func verifyCIE(milTransactionId: String, nis: String, ciePublicKey: String, signature: String, sod: String) async throws -> VerifyCIEResponse {
        VerifyCIEResponse.mocked
    }
    
    func verifyTransactionStatus(milTransactionId: String) async throws -> TransactionModel {
        let transactions = [TransactionModel.mockedIdentifiedTransaction, TransactionModel.mockedCreatedTransaction]
        return transactions.randomElement()!
    }
    
    func authorizeTransaction(milTransactionId: String, authCodeBlockData: AuthCodeData) async throws -> Bool {
        if milTransactionId == MockedNetworkClient.validTransactionID {
            return true
        } else {
            throw HTTPResponseError.unauthorized
        }
    }
    
    func deleteTransaction(milTransactionId: String) async throws -> Bool {
        if milTransactionId == MockedNetworkClient.validTransactionID {
            return true
        } else {
            throw HTTPResponseError.unauthorized
        }
    }
    
    func transactionHistory() async throws -> [TransactionModel] {
        print("Delay transaction history loading")
        try? await Task.sleep(nanoseconds: 1 * 2_000_000_000)
        if let mockFileName = ProcessInfo.processInfo.environment["-mock-filename"] {
            do {
                var transactionsList: TransactionHistoryResponse = try UITestingHelper.getMockedObject(jsonName: mockFileName)!
                var transactions = transactionsList.transactions
                
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
