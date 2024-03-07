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

    public func encrypt(messageData: Data?) -> Data? {
        guard let messageData else { return nil}
        return crypt(data: messageData, option: CCOperation(kCCEncrypt))
    }

    public func decrypt(encryptedData: Data?) -> Data? {
        return crypt(data: encryptedData, option: CCOperation(kCCDecrypt))
    }

    private func crypt(data: Data?, option: CCOperation) -> Data? {
        guard let data = data else { return nil }
        var outputBuffer = [UInt8](repeating: 0, count: data.count + kCCBlockSizeAES128)
        var numBytesEncrypted = 0
        let ivBytes: [UInt8] = [UInt8](repeating: 0, count: 16)
        let iv = Data(ivBytes)
        let status = CCCrypt(
            option,
            CCAlgorithm(kCCAlgorithmAES),
            CCOptions(kCCOptionPKCS7Padding),
            (key as NSData).bytes,
            kCCKeySizeAES256,
            (iv as NSData).bytes,
            (data as NSData).bytes,
            data.count,
            &outputBuffer, outputBuffer.count, &numBytesEncrypted
        )
        guard status == kCCSuccess else { return nil }
        let outputBytes = outputBuffer.prefix(numBytesEncrypted)
        return Data(outputBytes)
    }
}
