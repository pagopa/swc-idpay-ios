//
//  LoginViewUITests.swift
//  SWC-iDPay-iOSUITests
//
//  Created by Stefania Castiglioni on 15/01/24.
//

import XCTest

final class LoginViewUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    func test_access_button_is_disabled_when_username_password_are_empty() {
        let loginButton = app.buttons["Accedi"]
        XCTAssert(loginButton.waitForExistence(timeout: 5.0))
        XCTAssertFalse(loginButton.isEnabled, "Login button should be disabled if textfields are empty")
    }
}
