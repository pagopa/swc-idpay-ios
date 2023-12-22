//
//  SWC_iDPay_iOSApp.swift
//  SWC-iDPay-iOS
//
//  Created by Pier Domenico Bonamassa on 29/11/23.
//

import SwiftUI
import PagoPAUIKit

@main
struct SWC_iDPay_iOSApp: App {
    @StateObject var appManager = AppStateManager()
    
    init() {
        Font.registerPagoPAFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                switch appManager.state {
                case .splash:
                    SplashView {
                        DispatchQueue.main.async {
                            appManager.state = .login
                        }
                    }
                case .login:
                    LoginView {
                        DispatchQueue.main.async {
                            appManager.state = .main
                        }
                    }
                case .main:
                    ComponentsDemoListView()
                }
            }
//            .animation(.easeInOut(duration: 2.0), value: appManager.state)
            .environmentObject(appManager)
        }
    }
}
