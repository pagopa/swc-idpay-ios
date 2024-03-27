//
//  XCUIElement+Extensions.swift
//  SWC-iDPay-iOSUITests
//
//  Created by Stefania Castiglioni on 17/01/24.
//

import XCTest

extension XCUIElement
{
    func hasKeyboardFocus() -> Bool {
        let hasKeyboardFocus = (self.value(forKey: "hasKeyboardFocus") as? Bool) ?? false
        return hasKeyboardFocus
    }
}
