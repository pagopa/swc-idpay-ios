//
//  Route.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 07/02/24.
//

import SwiftUI
import PagoPAUIKit

enum Route: View {
    case initiatives(viewModel: InitiativesViewModel)
    case bonusAmount(viewModel: BonusAmountViewModel)
    case thankyouPage(result: ResultModel)
    
    var showBackButton: Bool {
        switch self {
        case .thankyouPage:
            return false
        default:
            return true
        }
    }
    
    var showHomeButton: Bool {
        switch self {
        case .thankyouPage:
            return false
        default:
            return true
        }
    }
    
    var tintColor: Color {
        switch self {
        case .initiatives:
            return .paPrimary
        case .bonusAmount:
            return .paPrimary
        default:
            return .paPrimary
        }
    }
    
    var body: some View {
        switch self {
        case .initiatives(let viewModel):
            InitiativesList(viewModel: viewModel)
        case .bonusAmount(let viewModel):
            BonusAmountView(viewModel: viewModel)
        case .thankyouPage(let result):
            ThankyouPage(result: result)
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
        case (.thankyouPage(let lhsResult), .thankyouPage(let rhsResult)):
            return lhsResult.id == rhsResult.id
        default:
            return false
        }
    }
}
