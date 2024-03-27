//
//  ResidualAmountToolbar.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 21/03/24.
//

import SwiftUI
import PagoPAUIKit

struct ResidualAmountToolbarModifier: ViewModifier {
        
    @EnvironmentObject var router: Router
    @State private var showConfirmExit: Bool = false
    
    var residualAmount: Int
    var tintColor: Color
    var toolbarBkgColor: Color

    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    HomeButton {
                        showConfirmExit.toggle()
                    }
                    .foregroundColor(tintColor)
                }
            }
            .toolbarBackground(toolbarBkgColor, for: .navigationBar)
            .dialog(dialogModel: 
                        ResultModel(title: "Vuoi tornare alla home?",
                                    subtitle: "C'è un residuo da pagare di \(residualAmount.formattedCurrency).",
                                    themeType: .light,
                                   buttons: [
                                    ButtonModel(type: .primary,
                                                themeType: .light, 
                                                title: "Annulla",
                                                action: {
                                                    showConfirmExit.toggle()
                                                }),
                                    ButtonModel(type: .primaryBordered,
                                                themeType: .light,
                                                title: "Torna alla home", 
                                                action: {
                                                    router.popToRoot()
                                                })
                                   ]),
                    isPresenting: $showConfirmExit)
    }

}

extension View {
    
    func residualAmountToolbar(residualAmount: Int, tintColor: Color = .paPrimary, toolbarBkgColor: Color = .white) -> some View {
        modifier(ResidualAmountToolbarModifier(residualAmount: residualAmount, tintColor: tintColor, toolbarBkgColor: toolbarBkgColor))
    }
}
