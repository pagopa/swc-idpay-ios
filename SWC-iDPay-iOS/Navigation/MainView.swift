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
    
    var body: some View {
        Group {
            switch appManager.state {
            case .splash:
                SplashView(onComplete: {
                    appManager.moveTo(.login)
                })
            case .login:
                LoginView(viewModel: LoginViewModel(networkClient: appManager.networkClient), onLoggedIn: {
                    router.popToRoot()
                    appManager.loadHome()
                })
            case .acceptBonus:
                RootView {
                    HomeView(viewModel: HomeViewModel(networkClient: appManager.networkClient))
                }
                .environmentObject(router)
            case .transactionHistory:
                RootView(barTintColor: Color.paPrimary) {
                    TransactionsHistoryList(viewModel: TransactionHistoryViewModel(networkClient: appManager.networkClient))
                }
                .environmentObject(router)
            #if DEBUG
            case .uiKit:
                ComponentsDemoListView()
            #endif
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
            appManager.checkSession()
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name.sessionExpired)) { object in
            showSessionExpiredDialog()
        }
    }
}

extension MainView {
    func showSessionExpiredDialog() {
        DispatchQueue.main.async {
            DialogManager.shared.showDialog(dialogModel:
                                                sessionExpiredDialogModel(
                                                    appManager: appManager,
                                                    router: router))
        }
    }
}

#Preview {
    MainView()
}

extension Notification.Name {
    static let sessionExpired = Notification.Name("SessionExpiredNotification")
}
