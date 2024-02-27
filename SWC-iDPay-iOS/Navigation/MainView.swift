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
    var networkClient: Requestable = NetworkClient(environment: .development)
    
    var body: some View {
        switch appManager.state {
        case .splash:
            SplashView(onComplete: {
                appManager.moveTo(.login)
            })
        case .login:
            LoginView(viewModel: LoginViewModel(networkClient: networkClient), onLoggedIn: {
                appManager.login()
            })
        case .acceptBonus:
            RootView {
                HomeView(viewModel: HomeViewModel(networkClient: networkClient))
            }
        case .transactionHistory:
            RootView(barTintColor: Color.paPrimary) {
                TransactionsHistoryList(viewModel: TransactionHistoryViewModel(networkClient: networkClient))
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
