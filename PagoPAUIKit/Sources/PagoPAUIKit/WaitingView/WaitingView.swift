//
//  WaitingView.swift
//
//
//  Created by Pier Domenico Bonamassa on 22/12/23.
//

import SwiftUI

public struct WaitingView: View {
    
    private var title: String
    private var icon: Image.PAIcon?
    private var subtitle: String
    private var buttons: [ButtonModel]
    
    public init(title: String, subtitle: String, icon: Image.PAIcon? = nil, buttons: [ButtonModel] = []) {
        self.title = title
        self.icon = icon
        self.subtitle = subtitle
        self.buttons = buttons
    }
    
    public var body: some View {
        ZStack {
            Color.overlay75
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                ResultView(
                    result:
                        ResultModel(
                            title: title,
                            subtitle: subtitle,
                            icon: self.icon,
                            themeType: .info,
                            buttons: buttons,
                            showLoading: true
                        )
                )
                .padding(.bottom, Constants.largeSpacing)
                .padding(.top, Constants.largeSpacing)
            }
            .background(Color.infoLight)
            .cornerRadius(Constants.radius2)
            .padding(Constants.mediumSpacing)
        }
    }
}

struct WaitingViewModifier: ViewModifier {
    var title: String
    var subtitle: String
    var icon: Image.PAIcon?
    var buttons: [ButtonModel]
    @Binding var isPresenting: Bool
    
    func body(content: Content) -> some View {
        content
            .fullScreenCover(isPresented: $isPresenting) {
                WaitingView(title: title, subtitle: subtitle, icon: icon, buttons: buttons)
            }
    }
}

extension View {
    public func waitingView(title: String, subtitle: String, icon: Image.PAIcon? = nil, buttons: [ButtonModel] = [], isPresenting: Binding<Bool>) -> some View {
        modifier(WaitingViewModifier(title: title, subtitle: subtitle, icon: icon, buttons: buttons, isPresenting: isPresenting))
    }
}

public struct WaitingViewDemo: View {
    public init() {}
    public var body: some View {
        WaitingView(
            title: "Attendi autorizzazione",
            subtitle: "Per proseguire è necessario autorizzare l’operazione sull’app IO"
        )
    }
}

public struct WaitingViewPlainDemo: View {
    public init() {}
    public var body: some View {
        WaitingView(
            title: "Attendi autorizzazione",
            subtitle: "Per proseguire è necessario autorizzare l’operazione sull’app IO",
            buttons: [
                ButtonModel(
                    type: .plain,
                    themeType: .info,
                    title: "Annulla",
                    action: {
                        print("Accetta nuovo bonus")
                    }
                )]
        )
    }
}
#Preview("LoadingBaseDialog") {
    WaitingViewDemo()
}

#Preview("LoadingPlainDialog") {
    WaitingViewPlainDemo()
}
