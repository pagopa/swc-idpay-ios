//
//  LoginViewModel.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 16/01/24.
//
import SwiftUI

final class LoginViewModel: ObservableObject {
    
    @Published var username: String = ""
    @Published var password: String = ""
    
    #warning("Add network call to login")
    func login() async -> Bool {
        
        #if DEBUG
        if UITestingHelper.isUITesting {
            return UITestingHelper.isUserLoginSuccess
        } else {
            print("Call login in viewmodel with user:\(username), password: \(password)")
            try? await Task.sleep(nanoseconds: 1 * 4_000_000_000) // 4 second
            return password == "access"
        }
        #else
        return false
        #endif
    }

    var isFormValid: Bool {
        !(username.isEmpty || password.isEmpty)
    }

}

