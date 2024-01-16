//
//  LoginViewUITests.swift
//  SWC-iDPay-iOSUITests
//
//  Created by Stefania Castiglioni on 15/01/24.
//

import XCTest
@testable import SWC_iDPay_iOS

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
        
    func test_access_button_enabling_when_textfields_are_filled() throws {
        sleep(6)
        let loginButton = app.buttons["Accedi"]
        XCTAssertFalse(loginButton.isEnabled, "Login button should be disabled if textfields are empty")

        let elementsQuery = app.scrollViews.otherElements
        let usernameTextfield = elementsQuery.textFields["Username textfield"]
        usernameTextfield.tap()
        usernameTextfield.typeText("aaa")
        XCTAssertFalse(loginButton.isEnabled, "Login button should be disabled if password textfield is empty")

        let passwordTextfield = elementsQuery.secureTextFields["Password textfield"]
        passwordTextfield.tap()
        passwordTextfield.typeText("bbb")
        XCTAssertTrue(loginButton.isEnabled, "Login button should be enabled if textfields are filled in")
    }

    func test_initial_view_is_visible_when_login_succeeds() {
        sleep(4)
        let elementsQuery = app.scrollViews.otherElements
        let usernameTextfield = elementsQuery.textFields["Username textfield"]
        usernameTextfield.tap()
        usernameTextfield.typeText("aaa")

        let passwordTextfield = elementsQuery.secureTextFields["Password textfield"]
        passwordTextfield.tap()
        passwordTextfield.typeText("access")

        let loginButton = app.buttons["Accedi"]
        loginButton.tap()

        let navigationBar = app.navigationBars.firstMatch.waitForExistence(timeout: 5)
        XCTAssert(navigationBar, "Should show first view with NavigationStack")
    }
    
}
