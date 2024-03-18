//
//  Requestable.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 12/02/24.
//

import Foundation

protocol Requestable {
    
    var sessionManager: SessionManager { get }
    
    func login(username: String, password: String)  async throws
    func refreshToken() async throws
    func getInitiatives() async throws -> [Initiative]
    func createTransaction(initiativeId: String, amount: Int) async throws -> CreateTransactionResponse
    func verifyCIE(milTransactionId: String, nis: String, ciePublicKey: String, signature: String, sod: String) async throws -> VerifyCIEResponse
    func verifyTransactionStatus(milTransactionId: String) async throws -> TransactionModel
    func authorizeTransaction(milTransactionId: String, authCodeBlockData: AuthCodeData) async throws
    func deleteTransaction(milTransactionId: String) async throws -> Bool
    func transactionHistory() async throws -> [TransactionModel]
}
