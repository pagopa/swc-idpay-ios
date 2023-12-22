//
//  WaitingView.swift
//
//
//  Created by Pier Domenico Bonamassa on 22/12/23.
//

import SwiftUI

public struct WaitingView: View {
    
    var waitingModel: ResultModel
    @Binding var isPresenting: Bool
    
    public init(waitingModel: ResultModel, isPresenting: Binding<Bool>) {
        self.waitingModel = waitingModel
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
                                title: waitingModel.title,
                                subtitle: waitingModel.subtitle,
                                icon: waitingModel.icon,
                                themeType: waitingModel.themeType,
                                buttons: waitingModel.buttons,
                                showLoading:waitingModel.showLoading
                            )
                    )
                    .padding(.bottom, Constants.largeSpacing)
                    .padding(.top, Constants.largeSpacing)
                }
                .background(waitingModel.theme.backgroundColor)
                .cornerRadius(Constants.radius2)
                .padding(Constants.mediumSpacing)
            }
        }
        .animation(.spring(duration: 0.1), value: isPresenting)
        
    }
}

struct WaitingViewModifier: ViewModifier {
    var waitingModel: ResultModel
    @Binding var isPresenting: Bool
    
    func body(content: Content) -> some View {
        ZStack {
            content
            WaitingView(waitingModel: waitingModel, isPresenting: $isPresenting)
        }
    }
}

extension View {
    public func waitingView(waitingModel: ResultModel, isPresenting: Binding<Bool>) -> some View {
        modifier(WaitingViewModifier(waitingModel: waitingModel, isPresenting: isPresenting))
    }
}

public struct WaitingViewDemo: View {
    public init() {}
    public var body: some View {
        WaitingView(
            waitingModel:
                ResultModel(
                    title: "Attendi autorizzazione",
                    subtitle: "Per proseguire è necessario autorizzare l’operazione sull’app IO",
                    themeType: ThemeType.info,
                    buttons:[],
                    showLoading: true
                ),
            isPresenting: .constant(true)
        )
    }
}

public struct WaitingViewPlainDemo: View {
    public init() {}
    public var body: some View {
        WaitingView(
            waitingModel:
                ResultModel(
                    title: "Attendi autorizzazione",
                    subtitle: "Per proseguire è necessario autorizzare l’operazione sull’app IO",
                    themeType: ThemeType.info,
                    buttons:[
                        ButtonModel(
                        type: .plain,
                        themeType: .info,
                        title: "Annulla",
                        action: {
                            print("Accetta nuovo bonus")
                        }
                    )],
                    showLoading: true
                ),
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
