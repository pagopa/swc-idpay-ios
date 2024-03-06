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
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate: AppDelegate
   
    @StateObject var appManager = AppStateManager()
    
    init() {
        Font.registerPagoPAFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(appManager)
        }
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        #if DEBUG
        if UITestingHelper.isUITesting {
            print("---- Running UI Tests -----")
        }
        #endif
        return true
    }
}
