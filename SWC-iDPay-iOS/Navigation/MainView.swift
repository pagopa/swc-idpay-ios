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
    @State var networkClient: Requestable?
    
    var body: some View {
        switch appManager.state {
        case .splash:
            SplashView(onComplete: {
                appManager.moveTo(.login)
            })
        case .login:
            LoginView(viewModel: LoginViewModel(client: NetworkClient(environment: .staging)), onLoggedIn: { client in
                self.networkClient = client
                appManager.login()
            })
        case .acceptBonus:
            if let networkClient = networkClient {
                RootView {
                    HomeView(networkClient: networkClient)
                }
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
