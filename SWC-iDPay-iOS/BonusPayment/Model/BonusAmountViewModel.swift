//
//  BonusAmountViewModel.swift
//  SWC-iDPay-iOS
//
//  Created by Pier Domenico Bonamassa on 09/02/24.
//

import Foundation
import CIEScanner

@MainActor
class BonusAmountViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var reader = CIEReader(readCardMessage: "Appoggia la CIE sul dispositivo, in alto", confirmCardReadMessage: "Lettura completata")

    func createTransaction() async {
        isLoading = true
        try? await Task.sleep(nanoseconds: 1 * 2_000_000_000)
        isLoading = false
    }
    
    
}
