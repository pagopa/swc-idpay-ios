//
//  SessionManager.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 12/02/24.
//

import Foundation
import JWTDecode

class SessionManager {
    
    private let ACCESS_TOKEN_KEY    = "idpay_access_token"
    private let REFRESH_TOKEN_KEY   = "idpay_refresh_token"
    
    private var keychainManager: KeychainManager?
    
    init() {
        self.keychainManager = try? KeychainManager(privateLabel: "ipday-security")
    }
    
    func saveSessionData(_ loginData: LoginResponse) throws {
        
        if keychainManager != nil {
            try keychainManager!.saveString(string: loginData.accessToken, for: ACCESS_TOKEN_KEY)
            try keychainManager!.saveString(string: loginData.refreshToken, for: REFRESH_TOKEN_KEY)
        } else {
            throw KeychainManagerError.genericError(description: "Keychain Manager not found")
        }
    }
    
    func getAccessToken() throws -> String {
        
        guard let keychainManager = keychainManager else {
            throw KeychainManagerError.genericError(description: "Keychain Manager not found")
        }
        
        guard let accessToken = try keychainManager.getString(for: ACCESS_TOKEN_KEY) else {
            throw KeychainManagerError.itemNotFound
        }
        
        return accessToken
    }
    
    func isTokenExpired() throws -> Bool {
        let accessToken = try getAccessToken()
        let jwt = try decode(jwt: accessToken)
        return jwt.expired
    }
    
    func getRefreshToken() throws -> String? {
        guard let keychainManager = keychainManager else {
            throw KeychainManagerError.genericError(description: "Keychain Manager not found")
        }
                        
        return try keychainManager.getString(for: REFRESH_TOKEN_KEY)
    }
    
}
