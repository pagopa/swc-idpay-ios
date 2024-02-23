//
//  RootView.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 07/02/24.
//

import SwiftUI
import PagoPAUIKit

struct RootView<Content:View>: View {
    
    @StateObject var router: Router = Router()
    @State private var showSheet: Bool = false
    @State private var showHelp: Bool = false

    private let barTintColor: Color
    private let content: Content
    
    init(barTintColor: Color = .white, @ViewBuilder content: @escaping () -> Content) {
        self.barTintColor = barTintColor
        self.content = content()
    }
    
    var body: some View {
        NavigationStack(path: $router.navigationPath) {
            content
                .navigationDestination(for: Route.self) { route in
                    route
                        .customToolbar(tintColor: route.tintColor, toolbarBackgroundColor: route.toolbarBackgroundColor)
                        .environment(\.isBackButtonVisibile, route.showBackButton)
                        .environment(\.isHomeButtonVisibile, route.showHomeButton)
                }
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        HamburgerMenuButton {
                            showSheet.toggle()
                        }
                        .foregroundColor(barTintColor)
                        .disabled(showSheet)
                        .opacity(showSheet ? 0.5 : 1.0)
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .showSheet(isVisibile: $showSheet) {
                    MenuView(showMenu: $showSheet, showHelp: $showHelp)
                }
                .fullScreenCover(isPresented: $showHelp) {
                    HelpView()
                        .ignoresSafeArea()
                }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .environmentObject(router)

    }
}

#Preview {
    RootView {
        ZStack {
            Color.yellow
                .ignoresSafeArea()
            Text("Hello world")
        }
    }
    .environmentObject(Router())
}
