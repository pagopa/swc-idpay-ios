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

    init(modulus: String, exponent: String) throws {
        self.modulus = modulus
        self.exponent = exponent
        
        randomKey = String.randomString()
        AES256Crypter = try AES256(key: randomKey)
    }
    
    public func generatePublicKey() throws -> SecKey {
//        let keyData = try getKeyData()
        
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
    
    public func publicKeyToString(_ publicKey: SecKey) throws -> String {
        var error:Unmanaged<CFError>?
        
        guard let cfdata = SecKeyCopyExternalRepresentation(publicKey, &error) else {
            throw KeyFactoryError.invalidData
        }
        
        let data: Data = cfdata as Data
        return data.base64EncodedString()
    }
    
    public func encryptAES(_ string: String) throws -> String {
        
        guard let plainData = string.data(using: .utf8) else {
            throw KeyFactoryError.invalidData
        }
        
        guard let encryptedPinData = try AES256Crypter.encrypt(messageData: plainData) else {
            throw KeyFactoryError.genericError(description: "Unable to encrypt Pin data")
        }
        
//        var error: Unmanaged<CFError>?
//
//        guard let encryptedPinData = SecKeyCreateEncryptedData(publicKey, .rsaEncryptionOAEPSHA256, plainData as CFData, &error) else {
//            throw KeyFactoryError.genericError(description: "Error during PIN encryption\n \(error?.takeRetainedValue().localizedDescription ?? "")")
//        }

        return (encryptedPinData as Data).base64EncodedString()
    }
    
    func generate(pin: String, secondFactor: String) throws -> String {
        
        var pinBlock = "0\(pin.count)\(pin)"
        
        while (pinBlock.count != 16) {
            pinBlock += "F"
        }
        
        var hexPinBlock = pinBlock.byteArrayFromHexString()
        var hexSecondFactor = secondFactor.byteArrayFromHexString()
        
        guard hexPinBlock.count == hexSecondFactor.count else {
            throw KeyFactoryError.invalidData
        }
        
        var generated = [UInt8]()
        
        for i in 0..<hexPinBlock.count {
            generated.append(hexPinBlock[i] ^ hexSecondFactor[i])
        }
        
        
        return Data(generated).hexEncodedString(options: .upperCase)
    }
            
//    private func getKeyData() throws -> Data {
//        
//        
//        // Il data viene creato e salvando in un .der viene decodificato da openssl
//        var sequenceEncoded: [UInt8] = modulus + exponent
//        
//        let hexEncodedSequence = String.hexStringFromBinary(sequenceEncoded)
//
//        print("sequence encoded: \(hexEncodedSequence)")
//        
//        guard let data = hexEncodedSequence.data(using: .utf8) else {
//            throw KeyFactoryError.invalidData
//        }
//                
//        return data
//        
////        var modulusEncoded: [UInt8] = []
////        modulusEncoded.append(0x02)
////        modulusEncoded.append(contentsOf: lengthField(of: modulus))
////        modulusEncoded.append(contentsOf: modulus)
////        print("modulus encoded: \(modulusEncoded)")
////
////        var exponentEncoded: [UInt8] = []
////        exponentEncoded.append(0x02)
////        exponentEncoded.append(contentsOf: lengthField(of: exponent))
////        exponentEncoded.append(contentsOf: exponent)
////        print("exponent encoded: \(exponentEncoded)")
////
////        
////        var sequenceEncoded: [UInt8] = []
////        sequenceEncoded.append(0x30)
////        sequenceEncoded.append(contentsOf: lengthField(of: (modulusEncoded + exponentEncoded)))
////        sequenceEncoded.append(contentsOf: (modulusEncoded + exponentEncoded))
////        print("sequence encoded: \(sequenceEncoded)")
////
////        return Data(sequenceEncoded)
//
//    }

}

//func lengthField(of valueField: [UInt8]) -> [UInt8] {
//    var count = valueField.count
//
//    if count < 128 {
//        return [ UInt8(count) ]
//    }
//
//    // The number of bytes needed to encode count.
//    let lengthBytesCount = Int((log2(Double(count)) / 8) + 1)
//
//    // The first byte in the length field encoding the number of remaining bytes.
//    let firstLengthFieldByte = UInt8(128 + lengthBytesCount)
//
//    var lengthField: [UInt8] = []
//    for _ in 0..<lengthBytesCount {
//        // Take the last 8 bits of count.
//        let lengthByte = UInt8(count & 0xff)
//        // Add them to the length field.
//        lengthField.insert(lengthByte, at: 0)
//        // Delete the last 8 bits of count.
//        count = count >> 8
//    }
//
//    // Include the first byte.
//    lengthField.insert(firstLengthFieldByte, at: 0)
//
//    return lengthField
//}


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

extension String {
    
    static func randomString(length: Int = 32) -> String {
        let numbers = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).compactMap{ _ in
            guard let randomElement = numbers.randomElement() else {return nil}
            return randomElement
        })
    }

}
