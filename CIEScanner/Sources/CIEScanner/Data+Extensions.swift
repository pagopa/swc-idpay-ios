//
//  Data+Extensions.swift
//
//
//  Created by Stefania Castiglioni on 02/02/24.
//

import Foundation

extension Data {
    public struct HexEncodingOptions: OptionSet {
        public let rawValue: Int
        
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
        
        public static let upperCase = HexEncodingOptions(rawValue: 1 << 0)
    }

    public func hexEncodedString(options: HexEncodingOptions = []) -> String {
        let format = options.contains(.upperCase) ? "%02hhX" : "%02hhx"
        return map { String(format: format, $0) }.joined()
    }
}
