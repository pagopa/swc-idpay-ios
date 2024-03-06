//
//  CustomLazyLoadingButton.swift
//  
//
//  Created by Stefania Castiglioni on 28/11/23.
//

import SwiftUI

public struct CustomLazyLoadingButton<Content: View>: View {
    
    private var buttonType: PagoPAButtonType
    private var icon: Image.PAIcon?
    private var position: ImagePosition = .right
    private var themeType: ThemeType = .light
    private var theme: PagoPATheme
    @Binding var isLoading: Bool
    var action: () -> Void
    var label: () -> Content

    public init(buttonType: PagoPAButtonType,
                icon: Image.PAIcon? = nil,
                position: ImagePosition = .right,
                themeType: ThemeType = .light,
                isLoading: Binding<Bool>,
                action: @escaping () -> Void,
                label: @escaping () -> Content) {
        self.buttonType = buttonType
        self.icon = icon
        self.position = position
        self.themeType = themeType
        self.theme = ThemeManager.buildTheme(type: themeType)
        self._isLoading = isLoading
        self.action = action
        self.label = label
    }
    
    public var body: some View {
        
        Button {
            guard !isLoading else { return }
            action()
        } label: {
            ZStack {
                if !isLoading { label() } else { Text("") }

                if isLoading {
                    ZStack {
                        Capsule()
                            .frame(maxWidth: .infinity)
                            .overlay(
                                ShimmerAnimationView()
                                    .cornerRadius(40)
                            )
                            .padding(.vertical, Constants.xsmallSpacing)
                            .padding(.horizontal, Constants.mediumSpacing)

                    }
                }
            }
            .frame(maxHeight: Constants.mediumSpacing)
        }
        .pagoPAButtonStyle(
            buttonType: self.buttonType,
            icon: isLoading ? nil : self.icon,
            position: self.position,
            themeType: self.themeType
        )
    }
    
    private var spinnerColor: Color {
        
        if buttonType == .primaryBordered || buttonType == .secondaryBordered {
            return self.theme.spinnerSecondaryColor
        }
        return self.theme.spinnerPrimaryColor
    }
    
}


struct CustomLazyLoadingButton_Previews: PreviewProvider {
    
    static var previews: some View {
        CustomLazyLoadingButton(buttonType: .primary, isLoading: .constant(true)) {
            
        } label: {
            Text("Prova")
        }
        .padding(.horizontal, Constants.mediumSpacing)

    }
}
