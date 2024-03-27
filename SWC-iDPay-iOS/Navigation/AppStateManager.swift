//
//  AppStateManager.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 06/12/23.
//

import Foundation
import PagoPAUIKit

enum AppState {
    case splash
    case login
    case acceptBonus
    case transactionHistory
    #if DEBUG
    case uiKit
    #endif
}

@MainActor
class AppStateManager: ObservableObject {
    
    @Published private(set) var state: AppState
    
    private var sessionManager: SessionManager = SessionManager()
    var networkClient: Requestable

    init() {
        #if DEBUG
        networkClient = UITestingHelper.isUITesting ? MockedNetworkClient(sessionManager: sessionManager) : NetworkClient(environment: .development, sessionManager: sessionManager)
        #else
        networkClient = NetworkClient(environment: .staging, sessionManager: sessionManager)
        #endif
    
        state = .splash
    }
        
    func loadHome() {
        state = .acceptBonus
    }
    
    func logout() {
        networkClient.sessionManager.logout()
        state = .login
    }
    
    func moveTo(_ state: AppState) {
        guard state != self.state else { return }
        self.state = state
    }
}

extension AppStateManager {
    
    @MainActor
    func isSessionExpired() async throws -> Bool {
        switch state {
        case .splash, .login:
            break
        default:
            if sessionManager.isTokenExpired() {
                DialogManager.shared.present(content:
                                                WaitingView(
                                                    title: "Stiamo verificando la sessione...",
                                                    subtitle: "",
                                                    icon: .infoFilled))
                do {
                    try await networkClient.refreshToken()
                    DialogManager.shared.dismiss()
                    return false
                } catch {
                    #if DEBUG
                    print("Error on refresh token:\(error.localizedDescription)")
                    #endif
                    return true
                }
            }
        }
        return false
    }

}
