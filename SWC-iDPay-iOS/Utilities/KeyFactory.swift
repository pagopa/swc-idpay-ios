//
//  KeyFactory.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 21/02/24.
//

import Foundation
import Security


enum KeyFactoryError: Error {
    case invalidRandomKey
    case invalidData
    case genericError(description: String)
}

class KeyFactory {
    
    private let modulus: String
    private let exponent: String
    private let randomKey: String
    private let AES256Crypter: AES256
    private var publicKey: SecKey?
    
    init(modulus: String, exponent: String) throws {
        self.modulus = modulus
        self.exponent = exponent
        
        randomKey = String.randomString()
        AES256Crypter = try AES256(key: randomKey)
        self.publicKey = try self.generatePublicKey()
    }
    
    private func generatePublicKey() throws -> SecKey {

        let moduleData = try modulus.base64Data()
        let exponentData = try exponent.base64Data()
        
        let keyData = Data(modulus: moduleData, exponent: exponentData)
        
        let attributes: [String: Any] = [
            kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
            kSecAttrKeyClass as String: kSecAttrKeyClassPublic
        ]
        
        var error: Unmanaged<CFError>?
        guard let pubKey = SecKeyCreateWithData(keyData as CFData, attributes as CFDictionary, &error) else {
            throw KeyFactoryError.genericError(description: "Error during data encryption\n\(error?.takeRetainedValue().localizedDescription ?? "")")
        }
        
        return pubKey
    }
    
    public func encryptAESKeyWithRsa() throws -> String {
        
        guard let publicKey else {
            throw KeyFactoryError.genericError(description: "No public key found to encrypt")
        }
        
        var error: Unmanaged<CFError>?
        
        guard let encryptedAESKeyData = SecKeyCreateEncryptedData(publicKey, .rsaEncryptionOAEPSHA256, (AES256Crypter.key as CFData), &error) else {
            throw KeyFactoryError.genericError(description: "Error during AES key encryption\n \(error?.takeRetainedValue().localizedDescription ?? "")")
        }
        
        return (encryptedAESKeyData as Data).base64EncodedString()
    }
    
    public func encryptAES(_ pinblock: [UInt8]) throws -> String {
                
        guard let encryptedPinData = AES256Crypter.encrypt(byteArray: pinblock) else {
            throw KeyFactoryError.genericError(description: "Unable to encrypt Pin data")
        }
        
        return (encryptedPinData as Data).base64EncodedString()
    }
    
    func generate(pin: String, secondFactor: String) throws -> [UInt8] {
        
        var pinBlock = "0\(pin.count)\(pin)"
        
        while (pinBlock.count != 16) {
            pinBlock += "F"
        }
        
        let hexPinBlock = pinBlock.byteArrayFromHexString()
        let hexSecondFactor = secondFactor.byteArrayFromHexString()
        
        guard hexPinBlock.count == hexSecondFactor.count else {
            throw KeyFactoryError.invalidData
        }
        
        var generated = [UInt8]()
        
        for i in 0..<hexPinBlock.count {
            generated.append(hexPinBlock[i] ^ hexSecondFactor[i])
        }
        
        
        return generated
    }
    
}

private extension Data {
    
    init(modulus: Data, exponent: Data) {
        // Make sure neither the modulus nor the exponent start with a null byte
        var modulusBytes = [CUnsignedChar](UnsafeBufferPointer<CUnsignedChar>(start: (modulus as NSData).bytes.bindMemory(to: CUnsignedChar.self, capacity: modulus.count), count: modulus.count / MemoryLayout<CUnsignedChar>.size))
        let exponentBytes = [CUnsignedChar](UnsafeBufferPointer<CUnsignedChar>(start: (exponent as NSData).bytes.bindMemory(to: CUnsignedChar.self, capacity: exponent.count), count: exponent.count / MemoryLayout<CUnsignedChar>.size))
        
        // Make sure modulus starts with a 0x00
        if let prefix = modulusBytes.first , prefix != 0x00 {
            modulusBytes.insert(0x00, at: 0)
        }
        
        // Lengths
        let modulusLengthOctets = modulusBytes.count.encodedOctets()
        let exponentLengthOctets = exponentBytes.count.encodedOctets()
        
        // Total length is the sum of components + types
        let totalLengthOctets = (modulusLengthOctets.count + modulusBytes.count + exponentLengthOctets.count + exponentBytes.count + 2).encodedOctets()
        
        // Combine the two sets of data into a single container
        var builder: [CUnsignedChar] = []
        let data = NSMutableData()
        
        // Container type and size
        builder.append(0x30)
        builder.append(contentsOf: totalLengthOctets)
        data.append(builder, length: builder.count)
        builder.removeAll(keepingCapacity: false)
        
        // Modulus
        builder.append(0x02)
        builder.append(contentsOf: modulusLengthOctets)
        data.append(builder, length: builder.count)
        builder.removeAll(keepingCapacity: false)
        data.append(modulusBytes, length: modulusBytes.count)
        
        // Exponent
        builder.append(0x02)
        builder.append(contentsOf: exponentLengthOctets)
        data.append(builder, length: builder.count)
        data.append(exponentBytes, length: exponentBytes.count)
        
        self.init(bytes: data.bytes, count: data.length)
    }
}

/// Encoding/Decoding lengths as octets
///
private extension NSInteger {
    func encodedOctets() -> [CUnsignedChar] {
        // Short form
        if self < 128 {
            return [CUnsignedChar(self)];
        }
        
        // Long form
        let i = Int(log2(Double(self)) / 8 + 1)
        var len = self
        var result: [CUnsignedChar] = [CUnsignedChar(i + 0x80)]
        
        for _ in 0..<i {
            result.insert(CUnsignedChar(len & 0xFF), at: 1)
            len = len >> 8
        }
        
        return result
    }
    
    init?(octetBytes: [CUnsignedChar], startIdx: inout NSInteger) {
        if octetBytes[startIdx] < 128 {
            // Short form
            self.init(octetBytes[startIdx])
            startIdx += 1
        } else {
            // Long form
            let octets = NSInteger(octetBytes[startIdx] as UInt8 - 128)
            
            if octets > octetBytes.count - startIdx {
                self.init(0)
                return nil
            }
            
            var result = UInt64(0)
            
            for j in 1...octets {
                result = (result << 8)
                result = result + UInt64(octetBytes[startIdx + j])
            }
            
            startIdx += 1 + octets
            self.init(result)
        }
    }
}
