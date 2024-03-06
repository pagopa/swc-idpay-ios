//
//  Utils.swift
//
//
//  Created by Stefania Castiglioni on 30/01/24.
//

import Foundation

class Utils {
    
    /// Converts a byte to hexadecimal Integer
    /// - parameter val: the original byte to convert
    /// - returns: the Integer value for the input byte
    public func binToHex( _ val: UInt8 ) -> Int {
        let hexRep = String(format: "%02X", val)
        return Int(hexRep, radix: 16)!
    }
    
    /// Convert a slice array of bytes to hexadecimal UInt64
    /// - parameter val: original byte array
    /// - returns: the converted hexadecimal UInt64
    public func binToHex( _ val: ArraySlice<UInt8> ) -> UInt64 {
        return binToHex( [UInt8](val) )
    }
    
    /// Convert a byte array to hexadecimal UInt64
    /// - parameter val: original byte array
    /// - returns: the converted hexadecimal UInt64
    public func binToHex( _ val: [UInt8] ) -> UInt64 {
        let hexVal = UInt64(String.hexStringFromBinary(val), radix: 16)!
        return hexVal
    }
    
    /// Retrieve subArray from byte array
    /// - parameter origin: original byte array
    /// - parameter start: start index for the new subarray
    /// - parameter count: end index for the new subarray
    /// - returns: the sliced array from start index to end index
    public static func getSubArray(from origin: [UInt8], start: Int, end: Int) -> [UInt8] {
        return [UInt8](origin[start..<end])
    }

}
