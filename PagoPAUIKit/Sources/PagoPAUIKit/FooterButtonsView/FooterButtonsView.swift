//
//  FooterButtonsView.swift
//  
//
//  Created by Pier Domenico Bonamassa on 15/02/24.
//

import SwiftUI

public struct FooterButtonsView: View {
    var buttons: [ButtonModel]
    
    public init(buttons: [ButtonModel]) {
        self.buttons = buttons
    }
    
    public var body: some View {
        VStack(spacing: Constants.mediumSpacing) {
            ForEach(buttons) { button in
                Button(action: button.action, label: {
                    Text(button.title)
                })
                .pagoPAButtonStyle(buttonModel: button)
            }
        }
        .padding(Constants.mediumSpacing)
        .background(
            UnevenRoundedRectangle(cornerRadii: .init(
                topLeading: Constants.mediumSpacing,
                bottomLeading: 0,
                bottomTrailing: 0,
                topTrailing: Constants.mediumSpacing),
                                   style: .continuous
                                   
            )
            .ignoresSafeArea()
            .foregroundColor(.white)
        )
        
    }
}

public struct FooterButtonsDemoView: View {
    
    public init() {}
    
    public var body: some View {
        VStack {
            Spacer()
            FooterButtonsView(
                buttons:
                    [ButtonModel(
                        type: .primaryBordered,
                        themeType: .light,
                        title: "Nega",
                        action: {
                            print("Nega")
                        }
                    ),
                     ButtonModel(
                        type: .primary,
                        themeType: .light,
                        title: "Conferma",
                        action: {
                            print("Conferma")
                        }
                     )]
            )
        }
        .background(Color.grey100)
    }
}

public struct FooterSingleButtonDemoView: View {
    
    public init() {}
    
    public var body: some View {
        VStack {
            Spacer()
            FooterButtonsView(
                buttons:
                    [ButtonModel(
                        type: .primary,
                        themeType: .light,
                        title: "Conferma",
                        action: {
                            print("Conferma")
                        }
                     )]
            )
        }
        .background(Color.grey100)
    }
}

#Preview("Footer multi buttons view") {
    FooterButtonsDemoView()
}

#Preview("Footer single buttons view") {
    FooterSingleButtonDemoView()
}
