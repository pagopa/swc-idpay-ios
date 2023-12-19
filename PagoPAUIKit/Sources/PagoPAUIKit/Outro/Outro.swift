//
//  Outro.swift
//
//
//  Created by Stefania Castiglioni on 15/12/23.
//

import SwiftUI

public struct Outro: View {
    var title: String
    var subtitle: String?
    var actionTitle: String
    var action: () -> Void
    
    public init(title: String, subtitle: String?, actionTitle: String, action: @escaping () -> Void) {
        self.title = title
        self.subtitle = subtitle
        self.actionTitle = actionTitle
        self.action = action
    }
    
    public var body: some View {
        
        ResultView(result:
                    ResultModel(
                        title: title,
                        subtitle: subtitle,
                        themeType: .dark,
                        buttons: [
                            ButtonModel(
                                type: .primary,
                                themeType: .dark,
                                title: actionTitle,
                                action: action
                            )]
                    )
        )
        .fullScreenBackground(themeType: .dark)
    }
}

#Preview("Outro") {
    Outro(
        title: "Operazione conclusa",
        subtitle: "Puoi riemettere la ricevuta in un momento successivo dalla sezione ‘Storico operazioni’.",
        actionTitle: "Paga l'importo residuo") {
        print("Paga l'importo residuo")
    }
}
