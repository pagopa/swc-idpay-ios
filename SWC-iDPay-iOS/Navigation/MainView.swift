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
        switch appManager.state {
        case .splash:
            SplashView(onComplete: {
                appManager.moveTo(.login)
            })
        case .login:
            LoginView(viewModel: LoginViewModel(), onLoggedIn: {
                appManager.login()
            })
        case .acceptBonus:
            RootView {
                HomeView()
            }
        case .transactionHistory:
            RootView(barTintColor: Color.paPrimary) {
                TransactionsHistoryList()
            }
        #if DEBUG
        case .uiKit:
            ComponentsDemoListView()
        #endif
        }
    }
}

#Preview {
    MainView()
}
