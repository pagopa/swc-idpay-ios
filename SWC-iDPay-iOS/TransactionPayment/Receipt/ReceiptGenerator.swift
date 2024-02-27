//
//  ReceiptGenerator.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 27/02/24.
//

import Foundation
import SwiftUI
import PagoPAUIKit

protocol ReceiptGenerator where Self: View {
    func generatePdfReceipt(model: ReceiptPdfModel) -> URL
}

extension ReceiptGenerator {
    @MainActor
    func generatePdfReceipt(model: ReceiptPdfModel) -> URL {
        
        return ReceiptPdfBuilderView(
            receiptTicketVM: model
        )
        .renderToPdf(
            filename: "receipt.pdf",
            location: URL.temporaryDirectory
        )
    }

}
