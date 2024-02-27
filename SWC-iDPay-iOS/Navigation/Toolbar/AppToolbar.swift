//
//  AppToolbar.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 07/02/24.
//

import SwiftUI

struct CustomToolbarModifier: ViewModifier {
    
    @EnvironmentObject var appManager: AppStateManager
    @EnvironmentObject var router: Router
    @Environment(\.isBackButtonVisibile) var isBackVisible: Bool
    @Environment(\.isHomeButtonVisibile) var isHomeVisible: Bool
    var tintColor: Color
    var toolbarBackgroundColor: Color

    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(true)
            .toolbar {
                if isBackVisible {
                    ToolbarItem(placement: .topBarLeading) {
                        BackButton {
                            router.pop()
                        }
                        .foregroundColor(tintColor)
                    }
                }
                    
                if isHomeVisible {
                    ToolbarItem(placement: .topBarTrailing) {
                        HomeButton {
                            router.popToRoot()
                            appManager.loadHome()
                        }
                        .foregroundColor(tintColor)
                    }
                }
            }
            .toolbarBackground(toolbarBackgroundColor, for: .navigationBar)
    }
    
    enum BackVisibleKey: EnvironmentKey {
        static var defaultValue: Bool = true
    }
    
    enum HomeVisibleKey: EnvironmentKey {
        static var defaultValue: Bool = true
    }
}

extension EnvironmentValues {
    var isBackButtonVisibile: Bool {
        get { self[CustomToolbarModifier.BackVisibleKey.self]  }
        set { self[CustomToolbarModifier.BackVisibleKey.self] = newValue }
    }
    
    var isHomeButtonVisibile: Bool {
        get { self[CustomToolbarModifier.HomeVisibleKey.self]  }
        set { self[CustomToolbarModifier.HomeVisibleKey.self] = newValue }
    }

}

extension View {
    
    func customToolbar(tintColor: Color = .white, toolbarBackgroundColor: Color = .white) -> some View {
        modifier(CustomToolbarModifier(tintColor: tintColor, toolbarBackgroundColor: toolbarBackgroundColor))
    }
}

