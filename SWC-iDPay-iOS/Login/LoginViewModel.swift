//
//  LoginViewModel.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 16/01/24.
//
import SwiftUI

final class LoginViewModel: BaseVM {
    
    @Published var username: String = ""
    @Published var password: String = ""
        
    func login() async throws -> Bool {
        
        #if DEBUG
        if UITestingHelper.isUITesting {
            print("Wait to login")
            try? await Task.sleep(nanoseconds: 1 * 4_000_000_000) // 4 second
            return UITestingHelper.isUserLoginSuccess
        } else {
            do {
                try await networkClient.login(username: username, password: password)
                return true
            } catch {
                return false
            }
//            print("Call login in viewmodel with user:\(username), password: \(password)")
//            try? await Task.sleep(nanoseconds: 1 * 4_000_000_000) // 4 second
//            return password == "access"
        }
        #else
        return false
        #endif
    }

    var isFormValid: Bool {
        !(username.isEmpty || password.isEmpty)
    }

}

