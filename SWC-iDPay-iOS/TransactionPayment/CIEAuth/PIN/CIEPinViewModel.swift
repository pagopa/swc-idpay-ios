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

    init(networkClient: Requestable, initiative: Initiative, transaction: TransactionModel, verifyCIEResponse: VerifyCIEResponse) {
        self.verifyCIEResponse = verifyCIEResponse
        self.transaction = transaction
        super.init(networkClient: networkClient, initiative: initiative, transactionID: transaction.transactionID, goodsCost: transaction.goodsCost)
    }
    
    func authorizeTransaction() async throws {
        Task {
            do {
                isLoading = true
                let authCodeData = try generateAuthCodeData()
                print("AuthCodeData:\n\(authCodeData)")
                let authorized = try await networkClient.authorizeTransaction(milTransactionId: transaction.transactionID, authCodeBlockData: authCodeData)
                print("Transaction Authorized")
                isLoading = false
            } catch {
                isLoading = false
                throw error
            }
        }
    }
    

    func generateAuthCodeData() throws -> AuthCodeData {
        
        let eDecoded = try String.decode(verifyCIEResponse.e) // exponent
        print("eDecoded: \(eDecoded)")
        var nDecoded = try String.decode(verifyCIEResponse.n) // modulus
        print("nDecoded: \(nDecoded)")
        
        do {
            let keyFactory = try KeyFactory(modulus: verifyCIEResponse.n, exponent: verifyCIEResponse.e)
            let publicKey = try keyFactory.generatePublicKey()
            let generated = try keyFactory.generate(pin: pinString, secondFactor: transaction.secondFactor)
            print("Generated pinBlock:\n\(generated)")
            let encryptedPin = try keyFactory.encryptAES(generated)
            let base64PublicKey = try keyFactory.publicKeyToString(publicKey)
            let encSessionKey = try keyFactory.encryptAES(base64PublicKey)
            
            return AuthCodeData(kid: verifyCIEResponse.kid, authCodeBlock: encryptedPin, encSessionKey: encSessionKey)
        } catch {
            print("Error encoding auth data:\(error.localizedDescription)")
            throw error
        }
    }

}
