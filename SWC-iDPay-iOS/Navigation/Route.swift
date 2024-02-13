//
//  Route.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 07/02/24.
//

import SwiftUI

enum Route: View {
    case initiatives(viewModel: InitiativesViewModel)
    case bonusAmount(viewModel: BonusAmountViewModel)
    
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
        case .initiatives(let viewModel):
            InitiativesList(viewModel: viewModel)
        case .bonusAmount(let viewModel):
            BonusAmountView(viewModel: viewModel)
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
