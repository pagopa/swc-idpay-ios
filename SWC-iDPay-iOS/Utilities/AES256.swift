//
//  AES256.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 22/02/24.
//

import Foundation
import CommonCrypto

enum AESError: Error {
    case keySizeError
    case keyDataError
}

public struct AES256 {
    public let key: Data

    public init(key: String) throws {
        guard key.count == kCCKeySizeAES256 else {
            throw AESError.keySizeError
        }
        guard let keyData = key.data(using: .utf8) else {
            throw AESError.keyDataError
        }
        self.key = keyData
    }
    
    public func encrypt(byteArray: [UInt8]?) -> Data? {
        guard let byteArray else { return nil}
        return crypt(byteArray: byteArray, option: CCOperation(kCCEncrypt))
    }

    public func decrypt(encryptedData: Data?) -> Data? {
        guard let encryptedData else { return nil }
        let byteArrayToDecrypt = encryptedData.hexEncodedString().byteArrayFromHexString()
        return crypt(byteArray: byteArrayToDecrypt, option: CCOperation(kCCDecrypt))
    }

    private func crypt(byteArray: [UInt8]?, option: CCOperation) -> Data? {
        guard let byteArray = byteArray else { return nil }
        var outputBuffer = [UInt8](repeating: 0, count: byteArray.count + kCCBlockSizeAES128)
        var numBytesEncrypted = 0
        let ivBytes: [UInt8] = [UInt8](repeating: 0, count: 16)
        let status = CCCrypt(
            option,
            CCAlgorithm(kCCAlgorithmAES),
            CCOptions(kCCOptionPKCS7Padding),
            (key as NSData).bytes,
            kCCKeySizeAES256,
            ivBytes,
            byteArray,
            byteArray.count,
            &outputBuffer, outputBuffer.count, &numBytesEncrypted
        )
        guard status == kCCSuccess else { return nil }
        let outputBytes = outputBuffer.prefix(numBytesEncrypted)
        return Data(outputBytes)
    }
}
