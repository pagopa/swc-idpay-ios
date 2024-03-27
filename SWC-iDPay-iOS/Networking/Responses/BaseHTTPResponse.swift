//
//  BaseHTTPResponse.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 16/02/24.
//

import Foundation

struct EmptyResponse: Decodable {}

struct BaseHTTPResponse: Decodable {
    var statusCode: Int?
    var errors: [String]?
    var descriptions: [String]?
}
