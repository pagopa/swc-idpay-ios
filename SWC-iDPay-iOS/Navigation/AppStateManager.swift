//
//  AppStateManager.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 06/12/23.
//

import Foundation

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

    init() {
        state = .splash
    }
        
    func login() {
        state = .acceptBonus
    }
    
    func logout() {
        state = .login
    }
    
    func moveTo(_ state: AppState) {
        self.state = state
    }
}
