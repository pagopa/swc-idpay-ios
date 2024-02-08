//
//  InitiativesViewModel.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 08/02/24.
//

import Foundation
import Combine

class InitiativesViewModel: ObservableObject {
    
    @Published var initiatives: [Initiative] = []
    
    init() {
        Task {
            await loadInitiatives()
        }
    }
    
    func loadInitiatives() async {
        try? await Task.sleep(nanoseconds: 1 * 2_000_000_000)
        initiatives = [
            Initiative.mocked,
            Initiative.mocked
        ]
    }
}
