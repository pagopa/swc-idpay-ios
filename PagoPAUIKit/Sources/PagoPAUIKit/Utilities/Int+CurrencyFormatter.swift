//
//  Int+CurrencyFormatter.swift
//
//
//  Created by Stefania Castiglioni on 11/01/24.
//

import Foundation

extension Int {
    public var formattedCurrency: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyDecimalSeparator = ","
        formatter.currencyCode = "EUR"
        formatter.maximumFractionDigits = 2

        let number = NSNumber(value: Double(self)/100.0)
        return formatter.string(from: number)!
    }
}
