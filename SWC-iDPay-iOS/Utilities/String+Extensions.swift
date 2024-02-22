//
//  String+Extensions.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 21/02/24.
//

import Foundation

extension String {
    
    func toBase64() -> String {
        let base64EncodedData = self.data(using: .utf8)!
        return base64EncodedData.base64EncodedString()
    }
}
