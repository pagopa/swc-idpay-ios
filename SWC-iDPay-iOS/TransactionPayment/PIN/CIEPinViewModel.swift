//
//  CIEPinViewModel.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 21/02/24.
//

import Foundation

class CIEPinViewModel: TransactionDeleteVM {
    
    @Published var pinString: String = ""
    
    var verifyCIEResponse: VerifyCIEResponse
    var transaction: TransactionModel
    
    init(networkClient: Requestable, transaction: TransactionModel, verifyCIEResponse: VerifyCIEResponse, initiative: Initiative? = nil) {
        self.verifyCIEResponse = verifyCIEResponse
        self.transaction = transaction
        super.init(networkClient: networkClient, transactionID: transaction.milTransactionId, goodsCost: transaction.goodsCost, initiative: initiative)
    }
    
    func authorizeTransaction() async throws -> Bool {
        do {
            loadingStateMessage = "Autorizzazione in corso"
            isLoading = true
            let authCodeData = try generateAuthCodeData()
            #if DEBUG
            print("AuthCodeData:\n\(authCodeData)")
            #endif
            let authorized = try await networkClient.authorizeTransaction(milTransactionId: transaction.milTransactionId, authCodeBlockData: authCodeData)
            print("Transaction Authorized")
            if authorized {
                transaction.status = .authorized
            }
            isLoading = false
            return authorized
        } catch {
            isLoading = false
            throw error
        }
    }
    
    
    func generateAuthCodeData() throws -> AuthCodeData {
        do {
            guard let secondFactor = transaction.secondFactor else {
                throw KeyFactoryError.genericError(description: "Second factor not found")
            }
            let keyFactory = try KeyFactory(modulus: verifyCIEResponse.n, exponent: verifyCIEResponse.e)
            let generated = try keyFactory.generate(pin: pinString, secondFactor: secondFactor)
            #if DEBUG
            print("Generated pinBlock:\n\(generated)")
            #endif
            let encryptedPin = try keyFactory.encryptAES(generated)
            let encSessionKey = try keyFactory.encryptAESKeyWithRsa()
            
            return AuthCodeData(kid: verifyCIEResponse.kid, authCodeBlock: encryptedPin, encSessionKey: encSessionKey)
        } catch {
            print("Error encoding auth data:\(error.localizedDescription)")
            throw error
        }
    }
    
}
