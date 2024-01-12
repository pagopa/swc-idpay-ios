//
//  Initiative.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 12/01/24.
//

import Foundation

struct Initiative: Codable {
    var id: String
    var name: String
    var organization: String
    
    fileprivate init(id: String, name: String, organization: String) {
        self.id = id
        self.name = name
        self.organization = organization
    }
}

extension Initiative {
    static var mocked: Self {
        Initiative(id: "649c50b5a03f655e6543af06", name: "Test funzionali Sconto tipo 6", organization: "Ente di test IDPay")
    }
}
