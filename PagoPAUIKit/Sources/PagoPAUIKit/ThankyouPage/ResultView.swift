//
//  ThankyouPage.swift
//
//
//  Created by Stefania Castiglioni on 14/12/23.
//

import SwiftUI

public struct ResultView: View {
    var title: String?
    var subtitle: String?
    var icon: Image.PAIcon?
    var theme: PagoPATheme
    var buttons: [ButtonModel]
    
    public init(title: String? = nil, subtitle: String? = nil, icon: Image.PAIcon? = nil, themeType: ThemeType, buttons: [ButtonModel] = []) {
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.theme = ThemeManager.buildTheme(type: themeType)
        self.buttons = buttons        
    }
    
    public var body: some View {
        ZStack {
            theme
                .backgroundColor
                .ignoresSafeArea()

            VStack(spacing: 0) {
                if let icon {
                    Image(icon: icon)
                        .padding(.bottom, Constants.mediumSpacing)
                } else if let defaultIcon = theme.defaultIcon {
                    Image(icon: defaultIcon)
                        .padding(.bottom, Constants.mediumSpacing)
                }
                if let title {
                    Text(title)
                        .multilineTextAlignment(.center)
                        .font(.PAFont.h3)
                        .foregroundColor(theme.titleColor)
                        .padding(.bottom, Constants.xsmallSpacing)
                }
                if let subtitle {
                    Text(subtitle)
                        .multilineTextAlignment(.center)
                        .font(.PAFont.body)
                        .foregroundColor(theme.subtitleColor)
                        .padding(.bottom, Constants.smallSpacing)
                }
                if buttons.count > 0 {
                    ForEach(buttons) { button in
                        Button(action: button.action, label: {
                            Text(button.title)
                        })
                        .pagoPAButtonStyle(buttonModel: button)
                        .padding(.top, Constants.mediumSpacing)
                        .padding(.horizontal, Constants.mediumSpacing)
                    }
                }
            }
            .padding(.horizontal, Constants.mediumSpacing)
        }
    }

}

#Preview("Warning Thankyou Page") {
    ResultView(
        title: "Titolo qualsiasi vvvv Titolo qualsiasi Titolo qualsiasi Titolo qualsiasi",
        subtitle: "Sottotitolo qulasiasi Sottotitolo qulasiasi ccccc Sottotitolo qulasiasi Sottotitolo qulasiasi Sottotitolo qulasiasi",
        themeType: .warning,
        buttons: [
            ButtonModel(
                type: .primary,
                themeType: .warning,
                title: "Accetta nuovo bonus",
                icon: .star,
                action: {
                    print("Accetta nuovo bonus")
                }
            ),
            ButtonModel(
                type: .secondaryBordered,
                themeType: .warning,
                title: "Riprova",
                action: {
                    print("Riprova")
                }
            )]
    )
}

#Preview("Success Thankyou Page") {
    ResultView(
        title: "Grazie, l'operazione è stata eseguita con successo!",
        themeType: .success,
        buttons: [
            ButtonModel(
                type: .primary,
                themeType: .success,
                title: "Continua",
                icon: .arrowRight,
                action: {
                    print("Continua")
                }
            )]
    )
}

#Preview("Error Thankyou Page") {
    ResultView(
        title: "L'operazione è stata annullata",
        subtitle: "Abbiamo riscontrato dei problemi con il pagamento, non è stato addebitato alcun importo.",
        themeType: .error,
        buttons: [
            ButtonModel(
                type: .primary,
                themeType: .error,
                title: "Torna alla home",
                action: {
                    print("Torna alla home")
                }
            )]
    )
}

#Preview("Info Thankyou Page") {
    ResultView(
        title: "L'operazione è stata presa in carico",
        subtitle: "Accedi al sito dell’ente per verificare lo stato dell’operazione",
        themeType: .info,
        buttons: [
            ButtonModel(
                type: .primary,
                themeType: .info,
                title: "Riprova",
                action: {
                    print("Riprova")
                }
            ),
            ButtonModel(
                type: .secondaryBordered,
                themeType: .info,
                title: "Accetta nuovo bonus",
                action: {
                    print("Accetta nuovo bonus")
                }
            )]
    )
}
