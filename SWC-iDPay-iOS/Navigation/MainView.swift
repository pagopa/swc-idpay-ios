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
    @StateObject var router: Router = Router()
    
    private var sessionManager: SessionManager = SessionManager()
    var networkClient: Requestable
    
    init() {
        self.sessionManager = SessionManager()
        
    #if DEBUG
        networkClient = UITestingHelper.isUITesting ? MockedNetworkClient(sessionManager: sessionManager) : NetworkClient(environment: .development, sessionManager: sessionManager)
    #else
        networkClient = NetworkClient(environment: .staging, sessionManager: sessionManager)
    #endif
    }
    
    var body: some View {
        Group {
            switch appManager.state {
            case .splash:
                SplashView(onComplete: {
                    appManager.moveTo(.login)
                })
            case .login:
                LoginView(viewModel: LoginViewModel(networkClient: networkClient), onLoggedIn: {
                    appManager.loadHome()
                })
            case .acceptBonus:
                RootView {
                    HomeView(viewModel: HomeViewModel(networkClient: networkClient))
                }
                .environmentObject(router)
            case .transactionHistory:
                RootView(barTintColor: Color.paPrimary) {
                    TransactionsHistoryList(viewModel: TransactionHistoryViewModel(networkClient: networkClient))
                }
                .environmentObject(router)
#if DEBUG
            case .uiKit:
                ComponentsDemoListView()
#endif
            }
        }
    }
}

#Preview {
    MainView()
}
