//
//  Button+PagoPAModifier.swift
//  
//
//  Created by Stefania Castiglioni on 22/11/23.
//

import SwiftUI

struct PAButtonStyle: ViewModifier {
    
    var buttonType: PagoPAButtonType
    var fullwidth: Bool
    var icon: Image.PAIcon? = nil
    var position: ImagePosition = .right
    var themeType: ThemeType = .light
    
    init(buttonType: PagoPAButtonType, fullwidth: Bool = true, icon: Image.PAIcon? = nil, position: ImagePosition, themeType: ThemeType) {
        self.buttonType = buttonType
        self.fullwidth = fullwidth
        self.icon = icon
        self.position = position
        self.themeType = themeType
    }
    
    init(buttonModel: ButtonModel, fullwidth: Bool = true) {
        self.buttonType = buttonModel.type
        self.fullwidth = fullwidth
        self.icon       = buttonModel.icon
        self.position   = buttonModel.iconPosition ?? .right
        self.themeType  = buttonModel.themeType
    }
    
    func body(content: Content) -> some View {
        content
            .buttonStyle(PagoPABaseButtonStyle(buttonType: buttonType, fullwidth: fullwidth, icon: icon, position: position, themeType: themeType))
    }
}

extension Button {
    public func pagoPAButtonStyle(buttonType: PagoPAButtonType, fullwidth: Bool = true, icon: Image.PAIcon? = nil, position: ImagePosition = .right, themeType: ThemeType = .light) -> some View {
        modifier(PAButtonStyle(buttonType: buttonType, fullwidth: fullwidth, icon: icon, position: position, themeType: themeType))
    }
    
    public func pagoPAButtonStyle(buttonModel: ButtonModel) -> some View {
        modifier(PAButtonStyle(buttonModel: buttonModel))
    }

}
