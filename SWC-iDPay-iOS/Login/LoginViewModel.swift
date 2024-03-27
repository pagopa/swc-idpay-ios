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
        do {
            try await networkClient.login(username: username, password: password)
            return true
        } catch {
            return false
        }
    }
    
    var isFormValid: Bool {
        !(username.isEmpty || password.isEmpty)
    }
    
}

