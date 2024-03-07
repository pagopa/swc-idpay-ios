//
//  IntroView.swift
//
//
//  Created by Stefania Castiglioni on 18/12/23.
//

import SwiftUI

public struct IntroView: View {
    
    public var title: String
    public var subtitle: String
    public var actionTitle: String
    public var action: () -> Void

    private var theme: PagoPATheme = DarkTheme()
    private var introAnimationDuration: Double = 4.0
    
    @State private var iconOpacity: CGFloat = 0.0
    @State private var titleOpacity: CGFloat = 0.0
    @State private var buttonOpacity: CGFloat = 0.0

    private var stepAnimationDuration: Double {
        introAnimationDuration/3.0
    }
    
    public init(title: String, subtitle: String, actionTitle: String, action: @escaping () -> Void) {
        self.title = title
        self.subtitle = subtitle
        self.actionTitle = actionTitle
        self.action = action
    }
    
    public var body: some View {
        ZStack {
            theme
                .backgroundColor
                .ignoresSafeArea()

            VStack(spacing: 0) {
                Image(icon: .bonus)
                    .resizable()
                    .frame(width: Constants.topIconSize, height: Constants.topIconSize)
                    .padding(.bottom, Constants.mediumSpacing)
                    .opacity(iconOpacity)
                    .foregroundColor(theme.titleColor)
                
                Text(title)
                    .multilineTextAlignment(.center)
                    .font(.PAFont.h3)
                    .foregroundColor(theme.titleColor)
                    .padding(.bottom, Constants.xsmallSpacing)
                    .opacity(titleOpacity)
                
                Text(subtitle)
                    .multilineTextAlignment(.center)
                    .font(.PAFont.body)
                    .foregroundColor(theme.subtitleColor)
                    .padding(.bottom, Constants.smallSpacing)
                    .opacity(titleOpacity)
                
                Button(action: action, label: {
                        Text(actionTitle)
                })
                .pagoPAButtonStyle(buttonType: .primary, fullwidth: false, themeType: .dark)
                .padding(.top, Constants.mediumSpacing)
                .padding(.horizontal, Constants.mediumSpacing)
                .opacity(buttonOpacity)
            }
            .padding(.horizontal, Constants.mediumSpacing)
            .onAppear {
                animateIntro()
            }
        }
    }
    
    func animateIntro() {
        withAnimation(.easeIn(duration: stepAnimationDuration)) {
            iconOpacity = 1.0
        }
        
        Timer.scheduledTimer(withTimeInterval: introAnimationDuration * 0.3, repeats: false) { _ in
            withAnimation(.easeInOut(duration: stepAnimationDuration)) {
                titleOpacity = 1.0
            }
        }
        
        Timer.scheduledTimer(withTimeInterval: introAnimationDuration * 0.6, repeats: false) { _ in
            withAnimation(.easeInOut(duration: stepAnimationDuration)) {
                buttonOpacity = 1.0
            }
        }
    }
}

#Preview {
    IntroView(
        title: "Accetta un bonus ID Pay",
        subtitle: "Inserisci i dettagli del pagamento e permetti ai tuoi clienti di utilizzare un bonus ID Pay.",
        actionTitle: "Accetta bonus ID Pay",
        action: {
            print("Inizia flusso bonus")
        }
    )
}
