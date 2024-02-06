//
//  Int+Extensions.swift
//  
//
//  Created by Stefania Castiglioni on 30/01/24.
//

import Foundation

extension Int {
    
    /// Converts an Integer to byte array with 0x00 format or 0x0000 format
    /// - parameter pad: the number of formatted hex values after 0x
    /// - returns: the converted byte array
    public func toByteArray(pad : Int = 2) -> [UInt8] {
        if pad == 2 {
            let hex = String(format:"%02x", self)
            return hex.byteArrayFromHexString()
        } else {
            let hex = String(format:"%04x", self)
            return hex.byteArrayFromHexString()
            
        }
    }
    
}
