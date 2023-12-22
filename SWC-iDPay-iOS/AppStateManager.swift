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
    case main
}

class AppStateManager: ObservableObject {
    @Published var state: AppState

    init() {
        state = .splash
    }
        
    func login() {
        state = .main
    }
}
