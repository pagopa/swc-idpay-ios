//
//  Initiative+TestExtension.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 28/02/24.
//

import Foundation

#if DEBUG
extension Initiative {

    init(name: String, organization: String) {
        self.id = "\(UUID())"
        self.name = name
        self.organization = organization
    }

    static var mocked: Self {
        Initiative(name: "Test funzionali Sconto tipo 6", organization: "Ente di test IDPay")
    }
}
#endif
