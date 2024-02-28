//
//  MockedNetworkClient.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 28/02/24.
//

import Foundation

class MockedNetworkClient: Requestable {
    
    static let validTransactionID = "fakeMilTransactionId"
    
    func login(username: String, password: String) async throws {
        print("Wait to login")
        try? await Task.sleep(nanoseconds: 1 * 4_000_000_000) // 4 second
        if UITestingHelper.isUserLoginSuccess {
            return
        } else {
            throw HTTPResponseError.unauthorized
        }
    }
    
    func getInitiatives() async throws -> [Initiative] {
        let initiativesResponse: InitiativesResponse = UITestingHelper.getMockedObject(jsonName: "InitiativesList")!
        return initiativesResponse.initiatives
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
        TransactionModel.randomTransactionsList
    }
    
    
}
