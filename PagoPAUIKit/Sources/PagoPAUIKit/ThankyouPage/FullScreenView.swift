//
//  FullScreenView.swift
//
//
//  Created by Pier Domenico Bonamassa on 19/12/23.
//

import SwiftUI

 struct FullScreenModifier: ViewModifier {
    var theme: PagoPATheme
    
    init(themeType: ThemeType) {
        self.theme = ThemeManager.buildTheme(type: themeType)
    }
    
    func body(content: Content) -> some View {
        ZStack {
            theme
                .backgroundColor
                .ignoresSafeArea()
            content
        }
    }
}

extension View {
    public func fullScreenBackground(themeType: ThemeType) -> some View {
        modifier(FullScreenModifier(themeType: themeType))
    }
}
