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
    case pin(viewModel: CIEPinViewModel)
    case receipt(receiptModel: ReceiptPdfModel, networkClient: Requestable)
    case outro(outroModel: OutroModel)
    case transactionDetail(viewModel: TransactionHistoryDetailViewModel)
    
    var showBackButton: Bool {
        switch self {
        case .thankyouPage, .transactionConfirm, .cieAuth, .pin, .receipt, .outro:
            return false
        default:
            return true
        }
    }
    
    var showHomeButton: Bool {
        switch self {
        case .thankyouPage, .transactionConfirm, .cieAuth, .pin, .receipt:
            return false
        default:
            return true
        }
    }
    
    var tintColor: Color {
        switch self {
        case .outro:
            return .white
        default:
            return .paPrimary
        }
    }
    
    var toolbarBackgroundColor: Color {
        switch self {
        case .outro:
            return .paPrimary
        default:
            return .white
        }
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
        case .transactionDetail(let viewModel):
            TransactionHistoryDetailView(viewModel: viewModel)
        case .pin(let viewModel):
            CIEPinView(viewModel: viewModel)
        case .receipt(let receiptModel, let networkClient):
            ReceiptConfirmView(receiptPdfModel: receiptModel, networkClient: networkClient)
        case .outro(let model):
            Outro(model: model)
        }
    }

}

extension Route: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.hashValue)
    }
    
    @MainActor static func == (lhs: Route, rhs: Route) -> Bool {
        switch (lhs, rhs) {
        case (.initiatives, .initiatives):
            return true
        case (.bonusAmount, .bonusAmount):
            return true
        case (.cieAuth(let lhsVM), .cieAuth(let rhsVM)):
            return lhsVM.transactionData.milTransactionId == rhsVM.transactionData.milTransactionId
        case (.transactionConfirm(let lhsVM), .transactionConfirm(let rhsVM)):
            return lhsVM.transaction.transactionID == rhsVM.transaction.transactionID
        case (.thankyouPage(let lhsResult), .thankyouPage(let rhsResult)):
            return lhsResult.id == rhsResult.id
        case (.transactionDetail(let lhsVM), .transactionDetail(let rhsVM)):
            return lhsVM.transaction.transactionID == rhsVM.transaction.transactionID
        case (.pin, .pin):
            return true
        case (.receipt(let lhsReceipt, _), .receipt(let rhsReceipt, _)):
            return lhsReceipt.transaction.transactionID == rhsReceipt.transaction.transactionID
        case (.outro(let lhsModel), .outro(let rhsModel)):
            return lhsModel.id == rhsModel.id
        default:
            return false
        }
    }
}
