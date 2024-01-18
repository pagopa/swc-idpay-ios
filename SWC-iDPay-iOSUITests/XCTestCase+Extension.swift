//
//  XCTestCase+Extension.swift
//  SWC-iDPay-iOSUITests
//
//  Created by Stefania Castiglioni on 18/01/24.
//

import XCTest

extension XCTestCase {
    
    @discardableResult func waitUntilElementHasFocus(element: XCUIElement, timeout: TimeInterval = 600) -> XCUIElement {
        
        let expectation = expectation(description: "waiting for \(element) to have focus")
        
        let timer = Timer(timeInterval: 1, repeats: true) { timer in
            guard element.hasKeyboardFocus() else { return }
            expectation.fulfill()
            timer.invalidate()
        }
        
        RunLoop.current.add(timer, forMode: .common)
        
        wait(for: [expectation], timeout: timeout)
        
        return element
    }
}
