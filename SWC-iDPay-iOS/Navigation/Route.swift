//
//  Route.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 07/02/24.
//

import SwiftUI

enum Route: View {
    case initiatives
    case bonusAmount
    
    var showBackButton: Bool {
        return true
    }
    
    var showHomeButton: Bool {
        return true
    }
    
    var tintColor: Color {
        switch self {
        case .initiatives:
            return .paPrimary
        case .bonusAmount:
            return .paPrimary
        }
    }
    
    var body: some View {
        switch self {
        case .initiatives:
            InitiativesList()
        case .bonusAmount:
            BonusAmountView()
        }
    }

}

extension Route: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.hashValue)
    }
    
    static func == (lhs: Route, rhs: Route) -> Bool {
        switch (lhs, rhs){
        case (.initiatives, .initiatives):
            return true
        case (.bonusAmount, .bonusAmount):
            return true
        default:
            return false
        }
    }
}
