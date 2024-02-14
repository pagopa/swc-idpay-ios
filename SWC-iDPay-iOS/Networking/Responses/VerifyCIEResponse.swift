//
//  VerifyCIEResponse.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 14/02/24.
//

import Foundation

struct VerifyCIEResponse: Decodable {
    
    var kty: String
    var e: String
    var use: String
    var kid: String
    var exp: Int32
    var iat: Int32
    var n: String
    var keyOps: [String]?

}
