//
//  KeychainManager.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 12/02/24.
//

import Foundation

enum KeychainManagerError: Error, CustomStringConvertible {
    case itemNotFound
    case invalidData
    case unhandledError(status: OSStatus)
    case genericError(description: String)

    public var description: String {
        
        switch self {
        case .itemNotFound: return "Item not found"
        case .invalidData: return "Data is invalid"
        case .unhandledError(let status): return "https://www.osstatus.com/search/results?platform=all&framework=Security&search=\(String(describing: status))"
        case .genericError(let description): return description
        }
    }
    
}

class KeychainManager {
    
    var privateTag: String
    var privateLabel: String
    
    public init(privateLabel: String) throws {
        
        self.privateLabel = privateLabel
        self.privateTag = Bundle.main.bundleIdentifier!
        
        let access = SecAccessControlCreateWithFlags(
            kCFAllocatorDefault,
            kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
            .privateKeyUsage,
            nil)! // Ignore errors.
        
        guard let _ = try? getPrivateKey(),
              let _ = try? getPublicKey() else {
            do {
                try generatePrivateKey(accessControl: access)
                return
            } catch { throw error }
        }
        
    }
    
    //MARK: - Private
    private func generatePrivateKey(accessControl: SecAccessControl) throws {
        
        let params: NSDictionary = [
            kSecAttrKeyType as String: kSecAttrKeyTypeECSECPrimeRandom,
            kSecAttrKeySizeInBits as String: 256,
            kSecAttrTokenID as String: kSecAttrTokenIDSecureEnclave,
            kSecPrivateKeyAttrs: [
                kSecAttrLabel as String: privateLabel,
                kSecAttrIsPermanent as String: true,
                kSecAttrApplicationTag as String: privateTag.data(using: .utf8)!,
                kSecAttrAccessControl as String: accessControl
            ]
        ]
        
        var error: Unmanaged<CFError>?
        guard let privateKey = SecKeyCreateRandomKey(params as CFDictionary, &error) else {
            throw error!.takeRetainedValue() as Error
        }
    }
    
    private func getPrivateKey() throws -> SecKey {
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrTokenID as String: kSecAttrTokenIDSecureEnclave,
            kSecAttrApplicationTag as String: privateTag.data(using: .utf8)!,
            kSecAttrLabel as String: privateLabel,
            kSecAttrKeyType as String: kSecAttrKeyTypeEC,
            kSecReturnRef as String: true
        ]
        
        
        var result: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status != errSecItemNotFound else {
            throw KeychainManagerError.itemNotFound
        }
        
        guard status == errSecSuccess else {
            throw KeychainManagerError.unhandledError(status: status)
        }
        return result as! SecKey
    }
    
    private func getPublicKey() throws -> SecKey {
        
        let privateKey = try getPrivateKey()
        guard let publicKey = SecKeyCopyPublicKey(privateKey) else {
            throw KeychainManagerError.itemNotFound
        }
        return publicKey
    }
    
    public func getString(for key: String) throws -> String? {
        
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrLabel as String: key,
                                    kSecAttrAccount as String: key,
                                    kSecMatchLimit as String: kSecMatchLimitOne,
                                    kSecReturnAttributes as String: true,
                                    kSecReturnData as String: true]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status != errSecItemNotFound else { throw KeychainManagerError.itemNotFound }
        guard status == errSecSuccess else { throw KeychainManagerError.unhandledError(status: status) }
        
        do {
            guard let existingItem = item as? [String : Any],
                let data = existingItem[kSecValueData as String] as? Data else {
                    throw KeychainManagerError.itemNotFound
            }
            return String(data: try decrypt(data), encoding: .utf8)
        } catch {
            throw KeychainManagerError.invalidData
        }
    }
    
    // MARK: - Deleting
    @discardableResult public func deleteString(for key: String) throws -> Bool {
        
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrLabel as String: key,
                                    kSecAttrAccount as String: key]
        
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else { throw KeychainManagerError.unhandledError(status: status) }

        return true
    }
    
    //MARK: - Saving
    public func saveString(string: String, for key: String) throws {
        
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrLabel as String: key,
                                    kSecAttrAccount as String: key,
                                    kSecMatchLimit as String: kSecMatchLimitOne,
                                    kSecReturnAttributes as String: false,
                                    kSecReturnData as String: false]
        
        var itemRef: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &itemRef)
        guard status != errSecItemNotFound else {
            
            do {
                guard let data = string.data(using: .utf8) else { throw KeychainManagerError.invalidData }
                let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                            kSecAttrLabel as String: key,
                                            kSecAttrAccount as String: key,
                                            kSecValueData as String: try encrypt(data)]
                let status = SecItemAdd(query as CFDictionary, nil)
                guard status == errSecSuccess else { throw KeychainManagerError.unhandledError(status: status) }
            } catch { throw error }
            return
        }
        
        try updateString(string: string, for: key)
    }
    
    //MARK: - Updating
    private func updateString(string: String, for key: String) throws {
        
        guard let data = string.data(using: .utf8) else { throw KeychainManagerError.invalidData }
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrAccount as String: key,
                                    kSecAttrLabel as String: key]
        let attributes: [String: Any] = [kSecValueData as String: try encrypt(data)]
        
        let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        guard status == errSecSuccess else { throw KeychainManagerError.unhandledError(status: status) }
    }
    
    //MARK: - Encrypt & Decrypt
    private func encrypt(_ digest: Data) throws -> Data {
        
        do {
            let publicKey = try getPublicKey()
            var error : Unmanaged<CFError>?
            guard let result = SecKeyCreateEncryptedData(publicKey, SecKeyAlgorithm.eciesEncryptionStandardX963SHA256AESGCM, digest as CFData, &error) else {
                throw KeychainManagerError.genericError(description: "Error during data decryption\n\(error?.takeRetainedValue().localizedDescription ?? "")")
            }
            return result as Data
        } catch { throw error }
    }
    
    private func decrypt(_ digest: Data) throws -> Data {
        
        do {
            let privateKey = try getPrivateKey()
            var error : Unmanaged<CFError>?
            guard let result = SecKeyCreateDecryptedData(privateKey, SecKeyAlgorithm.eciesEncryptionStandardX963SHA256AESGCM, digest as CFData, &error) else {
                throw KeychainManagerError.genericError(description: "Error during data encryption\n\(error?.takeRetainedValue().localizedDescription ?? "")")
            }
            return result as Data
        } catch {
            throw error
        }
    }


}

extension KeychainManager {
    
    private func errorLink(for status: OSStatus) -> String {
        return "https://www.osstatus.com/search/results?platform=all&framework=Security&search=\(String(describing: status))"
    }
    
}
