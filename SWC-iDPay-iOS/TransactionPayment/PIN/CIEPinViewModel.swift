//
//  CIEPinViewModel.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 21/02/24.
//

import Foundation
import PagoPAUIKit
import Combine

enum AuthorizationDialogState {
    case invalidCode
    case noMessage
}

class CIEPinViewModel: TransactionDeleteVM {
    
    @Published var pinString: String = ""
    @Published private(set) var authDialogState: AuthorizationDialogState = .noMessage
    @Published var showAuthDialog: Bool = false

    private var cancellables = Set<AnyCancellable>()

    var verifyCIEResponse: VerifyCIEResponse
    var transaction: TransactionModel
    var pinRetries: Int = 3
    
    init(networkClient: Requestable, transaction: TransactionModel, verifyCIEResponse: VerifyCIEResponse, initiative: Initiative? = nil) {
        self.verifyCIEResponse = verifyCIEResponse
        self.transaction = transaction
        super.init(networkClient: networkClient, transactionID: transaction.milTransactionId, goodsCost: transaction.goodsCost, initiative: initiative)
        
        $authDialogState
            .receive(on: DispatchQueue.main)
            .map { $0 != .noMessage }
            .assign(to: \.showAuthDialog, on: self)
            .store(in: &cancellables)
    }
    
    func dismissDialog() {
        authDialogState = .noMessage
    }
    
    func authorizeTransaction() async throws {
        do {
            loadingStateMessage = "Autorizzazione in corso"
            isLoading = true
            let authCodeData = try generateAuthCodeData()
            #if DEBUG
            print("AuthCodeData:\n\(authCodeData)")
            #endif
            try await networkClient.authorizeTransaction(milTransactionId: transaction.milTransactionId, authCodeBlockData: authCodeData)
            #if DEBUG
            print("Transaction Authorized")
            #endif
            transaction.status = .authorized
            isLoading = false
        } catch {
            isLoading = false
            pinString = ""
            switch error {
            case HTTPResponseError.invalidCode:
                pinRetries -= 1
                if pinRetries > 0 {
                    // mostra dialog warning Codice errato
                    authDialogState = .invalidCode
                }
                throw error
            default:
                print("mostra Autorizzazione negata")
                throw error
            }
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
