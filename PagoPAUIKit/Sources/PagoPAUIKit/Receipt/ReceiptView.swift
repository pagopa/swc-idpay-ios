//
//  ReceiptView.swift
//
//
//  Created by Stefania Castiglioni on 15/12/23.
//

import SwiftUI

public struct ReceiptView: View {
    var title: String
    var subtitle: String
    var buttons: [ButtonModel]
    
    public init(title: String, subtitle: String, buttons: [ButtonModel]) {
        self.title         = title
        self.subtitle      = subtitle
        self.buttons       = buttons
    }
    
    public var body: some View {
        ResultView(
            result: 
                ResultModel(
                    title: title,
                    subtitle: subtitle,
                    icon: .receipt,
                    themeType: .dark,
                    buttons: buttons
                )
        )
        .fullScreenBackground(themeType: .dark)
    }
}

#Preview("Receipt") {
    ReceiptView (
        title: "Serve la ricevuta?",
        subtitle: "Puoi riemettere la ricevuta in un momento successivo dalla sezione ‘Storico operazioni’.",
        buttons: [
            ButtonModel(
                type: .primary,
                themeType: .dark,
                title: "Invia via e-mail",
                icon: .mail,
                iconPosition: .left,
                action: {
                    print("Invia via e-mail")
                }
            ),
            ButtonModel(
                type: .primaryBordered,
                themeType: .dark,
                title: "Stampa",
                icon: .print,
                iconPosition: .left,
                action: {
                    print("Stampa")
                }
            ),
            ButtonModel(
                type: .primaryBordered,
                themeType: .dark,
                title: "No grazie",
                icon: .noReceipt,
                iconPosition: .left,
                action: {
                    print("Dismiss")
                }
            )]
    )
}
