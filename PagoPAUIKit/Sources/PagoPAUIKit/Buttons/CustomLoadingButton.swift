//
//  CustomLoadingButton.swift
//  
//
//  Created by Stefania Castiglioni on 24/11/23.
//

import SwiftUI

public struct CustomLoadingButton<Content: View>: View {
    
    private var buttonType: PagoPAButtonType
    private var fullwidth: Bool
    private var icon: Image.PAIcon?
    private var position: ImagePosition = .right
    private var themeType: ThemeType = .light
    private var theme: PagoPATheme
    @Binding var isLoading: Bool
    var action: () -> Void
    var label: () -> Content

    public init(buttonType: PagoPAButtonType,
                fullwidth: Bool = true,
                icon: Image.PAIcon? = nil,
                position: ImagePosition = .right,
                themeType: ThemeType = .light,
                isLoading: Binding<Bool>,
                action: @escaping () -> Void,
                label: @escaping () -> Content) {
        self.buttonType = buttonType
        self.fullwidth = fullwidth
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
            if !isLoading { label() } else { Text("") }
        }
        .pagoPAButtonStyle(
            buttonType: self.buttonType,
            fullwidth: fullwidth,
            icon: isLoading ? nil : self.icon,
            position: self.position,
            themeType: self.themeType
        )
        .animation(.easeInOut(duration: 0.3), value: isLoading)
        .showLoader(size: .cta, color: spinnerColor, isLoading: $isLoading)
    }
    
    private var spinnerColor: Color {
        
        if buttonType == .primaryBordered || buttonType == .secondaryBordered {
            return self.theme.spinnerSecondaryColor
        }
        return self.theme.spinnerPrimaryColor
    }
    
}

struct CustomLoadingButton_Previews: PreviewProvider {
    
    static var previews: some View {
        CustomLoadingButton(buttonType: .primary, isLoading: .constant(true)) {
            
        } label: {
            Text("Prova")
        }
        .padding(.horizontal, 24)

    }
}
