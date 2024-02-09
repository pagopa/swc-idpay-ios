//
//  Initiative.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 12/01/24.
//

import Foundation

struct Initiative: Codable, Identifiable, Equatable {
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
        Initiative(id: "\(UUID())", name: "Test funzionali Sconto tipo 6", organization: "Ente di test IDPay")
    }
}
