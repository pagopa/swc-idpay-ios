//
//  BaseHTTPResponse.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 16/02/24.
//

import Foundation

struct EmptyResponse: Decodable {}

struct BaseHTTPResponse: Decodable {
    var errors: [APIResponseError]?
        
    enum CodingKeys: CodingKey {
        case errors
    }
    
    init(from decoder: Decoder) throws {
        if let container: KeyedDecodingContainer<BaseHTTPResponse.CodingKeys> = 
            try? decoder.container(keyedBy: BaseHTTPResponse.CodingKeys.self) {
            self.errors = try? container.decodeIfPresent(
                [APIResponseError].self,
                forKey: BaseHTTPResponse.CodingKeys.errors
            )
        } else {
            self.errors = []
        }
    }
}
