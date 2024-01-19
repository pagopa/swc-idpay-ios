//
//  MainView.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 19/01/24.
//

import SwiftUI
import PagoPAUIKit

struct MainView: View {
    @EnvironmentObject var appManager: AppStateManager
    
    var body: some View {
        ZStack {
            switch appManager.state {
            case .splash:
                SplashView {
                    DispatchQueue.main.async {
                        appManager.state = .login
                    }
                }
            case .login:
                LoginView(viewModel: LoginViewModel()) {
                    DispatchQueue.main.async {
                        appManager.state = .main
                    }
                }
            case .main:
                ComponentsDemoListView()
            }
        }
    }
}

#Preview {
    MainView()
}
