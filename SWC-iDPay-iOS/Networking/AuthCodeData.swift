//
//  AuthCodeData.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 22/02/24.
//

import Foundation

struct AuthCodeData: Codable {
    var kid: String
    var authCodeBlock: String
    var encSessionKey: String
}
