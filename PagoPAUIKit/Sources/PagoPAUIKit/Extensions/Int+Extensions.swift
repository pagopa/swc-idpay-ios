//
//  Int+Extensions.swift
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
    
    public var formattedAmountNoCurrency: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.decimalSeparator = ","
        formatter.groupingSeparator = ""
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2

        guard self > 0 else {
            return formatter.string(from: NSNumber(value: 0.0))!
        }
        let number = NSNumber(value: Double(self)/100.0)
        return formatter.string(from: number)!
    }
}
