//
//  ResponseAPDU.swift
//  NFCTagReader
//
//  Created by Stefania Castiglioni on 25/01/24.
//

import Foundation

public struct ResponseAPDU {
    
    public var data : [UInt8]
    public var sw1 : UInt8
    public var sw2 : UInt8
    
    public init(data: [UInt8], sw1: UInt8, sw2: UInt8) {
        self.data = data
        self.sw1 = sw1
        self.sw2 = sw2
    }
}
