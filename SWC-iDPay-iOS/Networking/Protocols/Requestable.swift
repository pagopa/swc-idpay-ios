//
//  Requestable.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 12/02/24.
//

import Foundation

protocol Requestable {
    func login(username: String, password: String)  async throws
    func getInitiatives() async throws -> [Initiative]
    func createTransaction(initiativeId: String, amount: Int) async throws -> CreateTransactionResponse
    func verifyCIE(nis: String, ciePublicKey: String, signature: String, sod: String) 
    func authorizeTransaction() 
}
