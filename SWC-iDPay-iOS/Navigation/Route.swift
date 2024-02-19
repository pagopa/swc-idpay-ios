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
    case cieAuth(viewModel: CIEAuthViewModel)
    case transactionConfirm(viewModel: TransactionDetailViewModel)
    case thankyouPage(result: ResultModel)
    
    var showBackButton: Bool {
        switch self {
        case .thankyouPage, .transactionConfirm:
            return false
        default:
            return true
        }
    }
    
    var showHomeButton: Bool {
        switch self {
        case .thankyouPage, .transactionConfirm:
            return false
        default:
            return true
        }
    }
    
    var tintColor: Color {
        return .paPrimary
    }
    
    var body: some View {
        switch self {
        case .initiatives(let viewModel):
            InitiativesList(viewModel: viewModel)
        case .bonusAmount(let viewModel):
            BonusAmountView(viewModel: viewModel)
        case .cieAuth(let viewModel):
            CIEAuthView(viewModel: viewModel)
        case .transactionConfirm(let viewModel):
            TransactionDetailView(viewModel: viewModel)
        case .thankyouPage(let result):
            ThankyouPage(result: result)
        }
    }

}

extension Route: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.hashValue)
    }
    
    @MainActor static func == (lhs: Route, rhs: Route) -> Bool {
        switch (lhs, rhs){
        case (.initiatives, .initiatives):
            return true
        case (.bonusAmount, .bonusAmount):
            return true
        case (.cieAuth, .cieAuth):
            return true
        case (.transactionConfirm(let lhsVM), .transactionConfirm(let rhsVM)):
            return lhsVM.transaction.transactionID == rhsVM.transaction.transactionID
        case (.thankyouPage(let lhsResult), .thankyouPage(let rhsResult)):
            return lhsResult.id == rhsResult.id
        default:
            return false
        }
    }
}
