//
//  File.swift
//  
//
//  Created by Stefania Castiglioni on 26/01/24.
//

import Foundation

extension String {

    /// Converts a byte array in format 0x00 to a String
    /// - parameter val: the byte array to convert
    /// - returns: the converted String
    public static func hexStringFromBinary( _ val : [UInt8], asArray : Bool = false ) -> String {
        var string = asArray ? "[" : ""
        
        for i in 0..<val.count {
            if asArray {
                    string += String(format:"0x%02x", val[i] )
                if i < val.count-1 {
                    string += ", "
                }
            } else {
                string += String(format:"%02x", val[i])
            }
        }

        string += asArray ? "]" : ""
        return asArray ? string : string.uppercased()
    }

    /// Converts a byte as 0x00 to String
    /// - parameter val: the byte to convert
    /// - returns: the byte converted in String
    public static func hexStringFromBinary( _ val : UInt8 ) -> String {
        let string = String(format:"%02x", val ).uppercased()
        return string
    }
    
    /// Converts a String to byte array
    /// 'AABB' --> \xaa\xbb'"""
    public func byteArrayFromHexString() -> [UInt8] {
        var output : [UInt8] = []
        var x = self.startIndex
        while x < self.endIndex {
            if self.index(x, offsetBy: 2) <= self.endIndex {
                output.append( UInt8(self[x..<self.index(x, offsetBy: 2)], radix:16)! )
            } else {
                output.append( UInt8(self[x..<self.index(x, offsetBy: 1)], radix:16)! )

            }
            x = self.index(x, offsetBy: 2)
        }
        return output
    }

    public static func base64StringFromBinary(_ data: [UInt8]) -> String {
        return Data(data).base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
    }
    
    public static func decode(_ base64EncodedString: String) throws -> [UInt8] {
        
        let data = try base64EncodedString.base64Data()
        return [UInt8](data)
    }

    public func base64Data() throws -> Data {
        guard
            let base64EncodedData = self.data(using: .utf8),
            let data = Data(base64Encoded: base64EncodedData)
        else {
            throw DecodingError.invalidData
        }
        
        return data
    }
}

enum DecodingError: Error {
    case invalidData
    
}
