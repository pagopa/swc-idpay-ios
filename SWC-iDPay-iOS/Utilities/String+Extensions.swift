//
//  String+Extensions.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 21/02/24.
//

import Foundation

extension String {
    
    static var emptyDataPlaceholder = "N.D."
    
    func toBase64() -> String {
        let base64EncodedData = self.data(using: .utf8)!
        return base64EncodedData.base64EncodedString()
    }
    
    static func randomString(length: Int = 32) -> String {
        let numbers = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).compactMap { _ in
            guard let randomElement = numbers.randomElement() else {return nil}
            return randomElement
        })
    }

}
