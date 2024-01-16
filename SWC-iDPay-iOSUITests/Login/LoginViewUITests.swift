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
        app.launchArguments = ["-ui-testing"]
    }

    override func tearDownWithError() throws {
        app = nil
    }

    func test_access_button_is_disabled_when_username_password_are_empty() {
        app.launch()

        let loginButton = app.buttons["Accedi"]
        XCTAssert(loginButton.waitForExistence(timeout: 5.0))
        XCTAssertFalse(loginButton.isEnabled, "Login button should be disabled if textfields are empty")
    }
        
    func test_access_button_enabling_when_textfields_are_filled() throws {
        app.launch()

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
        app.launch()

        signIn(success: true)
        let navigationBar = app.navigationBars.firstMatch.waitForExistence(timeout: 5)
        XCTAssert(navigationBar, "Should show first view with NavigationStack")
    }
    
    func test_error_alert_is_visible_when_login_fails() {
        signIn(success: false)
        XCTAssertTrue(app.staticTexts["Accesso non riuscito. Hai inserito il nome utente e la password corretti?"].waitForExistence(timeout: 5), "Login error should be shown")
    }
}

extension LoginViewUITests {
    
    func signIn(success: Bool) {
        app.launchEnvironment["-user-login-success"] = success ? "1" : "0"
        app.launch()
        
        sleep(4)
        let elementsQuery = app.scrollViews.otherElements
        let usernameTextfield = elementsQuery.textFields["Username textfield"]
        usernameTextfield.tap()
        usernameTextfield.typeText("aaa")

        let passwordTextfield = elementsQuery.secureTextFields["Password textfield"]
        passwordTextfield.tap()
        passwordTextfield.typeText("ddd")

        let loginButton = app.buttons["Accedi"]
        loginButton.tap()
    }
}
