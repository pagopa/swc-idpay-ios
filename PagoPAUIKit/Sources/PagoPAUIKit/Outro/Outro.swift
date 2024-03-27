//
//  Outro.swift
//
//
//  Created by Stefania Castiglioni on 15/12/23.
//

import SwiftUI

public struct OutroModel {
    public var id = UUID()
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
}

public struct Outro: View {
    
    var model: OutroModel
    
    @State private var timer: Timer?
    
    public init(model: OutroModel) {
        self.model = model
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            Text(model.title)
                .multilineTextAlignment(.center)
                .font(.PAFont.h3)
                .foregroundColor(.white)
                .padding(.bottom, Constants.xsmallSpacing)
            
            if let subtitle = model.subtitle {
                Text(subtitle)
                    .multilineTextAlignment(.center)
                    .font(.PAFont.body)
                    .foregroundColor(.white)
                    .padding(.bottom, Constants.smallSpacing)
            }
            
            Button(action: model.action, label: {
                Text(model.actionTitle)
            })
            .pagoPAButtonStyle(buttonType: .primary, fullwidth: false, themeType: .dark)
            .padding(.top, Constants.mediumSpacing)
        }
        .padding(.horizontal, Constants.mediumSpacing)
        .fullScreenBackground(themeType: .dark)
        .onAppear {
            timer = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: false) { _ in
                model.action()
            }
        }
        .onDisappear {
            timer?.invalidate()
        }
    }
    
}

#Preview("Outro") {
    Outro(model: OutroModel(title: "Operazione conclusa",
                            subtitle: "Puoi riemettere la ricevuta in un momento successivo dalla sezione ‘Storico operazioni’.",
                            actionTitle: "Paga l'importo residuo",
                            action: {
                                print("Paga l'importo residuo")
                            }
                           )
    )
}
