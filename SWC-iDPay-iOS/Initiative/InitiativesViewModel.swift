//
//  InitiativesViewModel.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 08/02/24.
//

import Foundation
import Combine

@MainActor
class InitiativesViewModel: BaseVM {
    
    @Published var initiatives: [Initiative] = []
    @Published var isLoading: Bool = false
    @Published var showError: Bool = false
    @Published var loadingStateMessage: String = "Aspetta qualche istante"
    
    func loadInitiatives() {
        Task {
            isLoading = true
                        
            do {
                initiatives = try await networkClient.getInitiatives()
                isLoading = false
            } catch {
                isLoading = false
                showError = true
            }
        }
    }
}
