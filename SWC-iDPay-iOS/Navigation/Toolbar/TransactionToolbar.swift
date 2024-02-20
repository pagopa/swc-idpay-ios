//
//  TransactionToolbar.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 20/02/24.
//

import SwiftUI

struct TransactionToolbarModifier: ViewModifier {
        
    @EnvironmentObject var router: Router
    
    var viewModel: TransactionDeleteVM
    var showBack: Bool = true
    var tintColor: Color

    func body(content: Content) -> some View {
        content
            .toolbar {
                if showBack {
                    ToolbarItem(placement: .topBarLeading) {
                        BackButton {
                            confirmDelete()
                        }
                        .foregroundColor(tintColor)
                    }
                }
                    
                ToolbarItem(placement: .topBarTrailing) {
                    HomeButton {
                        confirmDelete()
                    }
                    .foregroundColor(tintColor)
                }
            }
            .toolbarBackground(.white, for: .navigationBar)
    }

    private func confirmDelete() {
        viewModel.confirmTransactionDelete()
    }
    
}

extension View {
    
    func transactionToolbar(viewModel: TransactionDeleteVM, showBack: Bool = true, tintColor: Color = .paPrimary) -> some View {
        modifier(TransactionToolbarModifier(viewModel: viewModel, showBack: showBack, tintColor: tintColor))
    }
}
