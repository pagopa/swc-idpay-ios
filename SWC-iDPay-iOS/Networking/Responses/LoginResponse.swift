//
//  LoginResponse.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 12/02/24.
//

import Foundation

struct LoginResponse: Decodable {
    var accessToken: String
    var refreshToken: String
    var tokenType: String
    var expiresIn: Int
}
