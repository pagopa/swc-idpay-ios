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
        VStack(spacing: 0) {
            Text(title)
                .multilineTextAlignment(.center)
                .font(.PAFont.h3)
                .foregroundColor(.white)
                .padding(.bottom, Constants.xsmallSpacing)
            
            if let subtitle = subtitle {
                Text(subtitle)
                    .multilineTextAlignment(.center)
                    .font(.PAFont.body)
                    .foregroundColor(.white)
                    .padding(.bottom, Constants.smallSpacing)
            }
            
            Button(action: action, label: {
                Text(actionTitle)
            })
            .pagoPAButtonStyle(buttonType: .primary, fullwidth: false, themeType: .dark)
            .padding(.top, Constants.mediumSpacing)
        }
        .padding(.horizontal, Constants.mediumSpacing)
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
