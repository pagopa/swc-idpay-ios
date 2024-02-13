//
//  SessionManager.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 12/02/24.
//

import Foundation
import JWTDecode

class SessionManager {
    
    private let ACCESS_TOKEN_KEY = "_ACCESS_TOKEN"
    private let REFRESH_TOKEN_KEY = "_REFRESH_TOKEN"
    
    private var keychainManager: KeychainManager?
    
    init() {
        self.keychainManager = try? KeychainManager(privateLabel: "ipday-security")
    }
    
    func saveSessionData(_ loginData: LoginResponse, username: String) throws {
        
        if keychainManager != nil {
            self.saveUsername(username)
            try keychainManager!.saveString(string: loginData.accessToken, for: "\(username)\(ACCESS_TOKEN_KEY)")
            try keychainManager!.saveString(string: loginData.refreshToken, for: "\(username)\(REFRESH_TOKEN_KEY)")
        } else {
            throw KeychainManagerError.genericError(description: "Keychain Manager not found")
        }
    }
    
    func getAccessToken() throws -> String {
        
        guard let keychainManager = keychainManager else {
            throw KeychainManagerError.genericError(description: "Keychain Manager not found")
        }
        
        guard let username = self.getUsername(), let accessToken = try keychainManager.getString(for: username + ACCESS_TOKEN_KEY) else {
            throw KeychainManagerError.itemNotFound
        }
        
        return accessToken
    }
    
    func isExpired(accessToken: String) throws -> Bool {
        let jwt = try decode(jwt: accessToken)
        return jwt.expired
    }
    
    func getRefreshToken() throws -> String? {
        guard let keychainManager = keychainManager else {
            throw KeychainManagerError.genericError(description: "Keychain Manager not found")
        }
        
        guard let username = self.getUsername() else {
            return nil
        }
                
        return try keychainManager.getString(for: username + REFRESH_TOKEN_KEY)
    }

    
    private func saveUsername(_ username: String) {
        let defaults = UserDefaults.standard
        defaults.setValue(username, forKey: "username")
    }
    
    func getUsername() -> String? {
        let defaults = UserDefaults.standard
        return defaults.string(forKey: "username")
    }
}
