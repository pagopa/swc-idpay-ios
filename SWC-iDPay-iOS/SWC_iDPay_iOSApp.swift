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

    var body: some Scene {
        WindowGroup {
            ZStack {
                switch appManager.state {
                case .splash:
                    SplashView {
                        appManager.state = .main
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
