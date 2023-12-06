//
//  Button+PagoPAModifier.swift
//  
//
//  Created by Stefania Castiglioni on 22/11/23.
//

import SwiftUI

struct PAButtonStyle: ViewModifier {
    
    var buttonType: PagoPAButtonType
    var icon: Image.PAIcon? = nil
    var position: ImagePosition = .right
    var themeType: ThemeType = .light
    
    func body(content: Content) -> some View {
        content
            .buttonStyle(PagoPABaseButtonStyle(buttonType: buttonType, icon: icon, position: position, themeType: themeType))
    }
}

extension Button {
    public func pagoPAButtonStyle(buttonType: PagoPAButtonType, icon: Image.PAIcon? = nil, position: ImagePosition = .right, themeType: ThemeType = .light) -> some View {
        modifier(PAButtonStyle(buttonType: buttonType, icon: icon, position: position, themeType: themeType))
    }
}
