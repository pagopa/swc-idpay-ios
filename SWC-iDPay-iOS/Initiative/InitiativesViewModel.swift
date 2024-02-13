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
        
    func loadInitiatives() {
        Task {
            isLoading = true
                        
            do {
                initiatives = try await networkClient.getInitiatives()
                isLoading = false
            } catch {
                isLoading = false
            }
//            try? await Task.sleep(nanoseconds: 1 * 2_000_000_000)
//            let initiativesCount = Int.random(in: 0...2)
//            
//            if initiativesCount > 0 {
//                for _ in 0..<initiativesCount {
//                    initiatives.append(Initiative.mocked)
//                }
//            }
        }
    }
}
