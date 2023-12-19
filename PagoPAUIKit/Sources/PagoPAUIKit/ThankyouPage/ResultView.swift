//
//  ThankyouPage.swift
//
//
//  Created by Stefania Castiglioni on 14/12/23.
//

import SwiftUI

struct ResultView: View {

    var result: ResultModel
    
    init(result: ResultModel) {
        self.result = result
    }
    
    var body: some View {
        
        VStack(spacing: 0) {
            if let icon = result.icon {
                Image(icon: icon)
                    .padding(.bottom, Constants.mediumSpacing)
            } else if let defaultIcon = result.theme.defaultIcon {
                Image(icon: defaultIcon)
                    .resizable()
                    .frame(width: Constants.topIconSize, height: Constants.topIconSize)
                    .padding(.bottom, Constants.mediumSpacing)
            }
            if let title = result.title {
                Text(title)
                    .multilineTextAlignment(.center)
                    .font(.PAFont.h3)
                    .foregroundColor(result.theme.titleColor)
                    .padding(.bottom, Constants.xsmallSpacing)
            }
            if let subtitle = result.subtitle {
                Text(subtitle)
                    .multilineTextAlignment(.center)
                    .font(.PAFont.body)
                    .foregroundColor(result.theme.subtitleColor)
                    .padding(.bottom, Constants.smallSpacing)
            }
            if result.showLoading == true {
                PAProgressView(themeType: result.themeType)
                    .padding(.horizontal, Constants.mediumSpacing)
                    .frame(maxHeight: 4)
            }
            if result.buttons.count > 0 {
                ForEach(result.buttons) { button in
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
