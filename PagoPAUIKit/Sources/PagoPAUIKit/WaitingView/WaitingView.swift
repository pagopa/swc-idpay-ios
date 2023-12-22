//
//  WaitingView.swift
//
//
//  Created by Pier Domenico Bonamassa on 22/12/23.
//

import SwiftUI

public struct WaitingView: View {
    
    private var title: String
    private var subtitle: String
    private var buttons: [ButtonModel]
    @Binding var isPresenting: Bool
    
    init(title: String, subtitle: String, buttons: [ButtonModel] = [], isPresenting: Binding<Bool>) {
        self.title = title
        self.subtitle = subtitle
        self.buttons = buttons
        _isPresenting = isPresenting
    }
    
    public var body: some View {
        ZStack {
            if isPresenting {
                Color.overlay75
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    ResultView(
                        result:
                            ResultModel(
                                title: title,
                                subtitle: subtitle,
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
        .animation(.spring(duration: 0.1), value: isPresenting)
        
    }
}

struct WaitingViewModifier: ViewModifier {
    var title: String
    var subtitle: String
    var buttons: [ButtonModel]
    @Binding var isPresenting: Bool
    
    func body(content: Content) -> some View {
        ZStack {
            content
            WaitingView(title: title, subtitle: subtitle, buttons: buttons, isPresenting: $isPresenting)
        }
    }
}

extension View {
    public func waitingView(title: String, subtitle: String, buttons: [ButtonModel] = [], isPresenting: Binding<Bool>) -> some View {
        modifier(WaitingViewModifier(title: title, subtitle: subtitle, buttons: buttons, isPresenting: isPresenting))
    }
}

public struct WaitingViewDemo: View {
    public init() {}
    public var body: some View {
        WaitingView(
            title: "Attendi autorizzazione",
            subtitle: "Per proseguire è necessario autorizzare l’operazione sull’app IO",
            isPresenting: .constant(true)
        )
    }
}

public struct WaitingViewPlainDemo: View {
    public init() {}
    public var body: some View {
        WaitingView(
            title: "Attendi autorizzazione",
            subtitle: "Per proseguire è necessario autorizzare l’operazione sull’app IO",
            buttons:[
                ButtonModel(
                    type: .plain,
                    themeType: .info,
                    title: "Annulla",
                    action: {
                        print("Accetta nuovo bonus")
                    }
                )],
            isPresenting: .constant(true)
        )
    }
}
#Preview("LoadingBaseDialog") {
    WaitingViewDemo()
}

#Preview("LoadingPlainDialog") {
    WaitingViewPlainDemo()
}
