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
    
    func test_username_is_focused_when_entering_login_view() {
        app.launch()
        let elementsQuery = app.scrollViews.otherElements
        let usernameTextfield = elementsQuery.textFields["Username textfield"]
        XCTAssert(usernameTextfield.waitForExistence(timeout: 6))
        waitUntilElementHasFocus(element: usernameTextfield)
        XCTAssertTrue(usernameTextfield.hasKeyboardFocus(), "Username should be selected when entering login view")
    }
    
    func test_unfocus_textfields_when_tapping_on_view() {
        app.launch()
        
        let elementsQuery = app.scrollViews.otherElements
        let usernameTextfield = elementsQuery.textFields["Username textfield"]
        let passwordTextfield = elementsQuery.secureTextFields["Password textfield"]
        XCTAssert(usernameTextfield.waitForExistence(timeout: 6))
        waitUntilElementHasFocus(element: usernameTextfield)
        XCTAssertTrue(usernameTextfield.hasKeyboardFocus(), "Username should be selected when entering login view")

        app.scrollViews.firstMatch.tap()
        
        XCTAssertFalse((usernameTextfield.hasKeyboardFocus() && passwordTextfield.hasKeyboardFocus()), 
                       "Textfields should not have focus"
        )
    }

    func test_access_button_is_disabled_when_username_password_are_empty() {
        app.launch()

        let loginButton = app.buttons["Accedi"]
        XCTAssert(loginButton.waitForExistence(timeout: 5.0))
        XCTAssertFalse(loginButton.isEnabled, "Login button should be disabled if textfields are empty")
    }
        
    func test_access_button_enabling_when_textfields_are_filled() throws {
        app.launch()

        let loginButton = app.buttons["Accedi"]
        XCTAssert(loginButton.waitForExistence(timeout: 6))
        XCTAssertFalse(loginButton.isEnabled, "Login button should be disabled if textfields are empty")

        let elementsQuery = app.scrollViews.otherElements
        let usernameTextfield = elementsQuery.textFields["Username textfield"]
        waitUntilElementHasFocus(element: usernameTextfield)
        usernameTextfield.typeText("aaa")
        XCTAssertFalse(loginButton.isEnabled, "Login button should be disabled if password textfield is empty")

        let passwordTextfield = elementsQuery.secureTextFields["Password textfield"]
        passwordTextfield.tap()
        passwordTextfield.typeText("bbb")
        XCTAssertTrue(loginButton.isEnabled, "Login button should be enabled if textfields are filled in")
    }
    
    func test_password_textfield_is_focused_when_tapping_next_from_username() {
        
        app.launch()

        let elementsQuery = app.scrollViews.otherElements
        let usernameTextfield = elementsQuery.textFields["Username textfield"]
        XCTAssert(usernameTextfield.waitForExistence(timeout: 6))
        let passwordTextfield = elementsQuery.secureTextFields["Password textfield"]

        waitUntilElementHasFocus(element: usernameTextfield)
        usernameTextfield.typeText("test")
        app.keyboards.buttons["avanti"].tap()
        waitUntilElementHasFocus(element: passwordTextfield)
        XCTAssertTrue(passwordTextfield.hasKeyboardFocus(), 
                      "Should select next textfield in form on next button tapped"
        )
    }
    
    func test_ui_isloading_when_tapping_login_button() {
        app.launchEnvironment["-user-login-success"] = "1"
        app.launch()

        let elementsQuery = app.scrollViews.otherElements
        let usernameTextfield = elementsQuery.textFields["Username textfield"]
        XCTAssert(usernameTextfield.waitForExistence(timeout: 6))
        let passwordTextfield = elementsQuery.secureTextFields["Password textfield"]

        waitUntilElementHasFocus(element: usernameTextfield)
        usernameTextfield.typeText("test")
        app.keyboards.buttons["avanti"].tap()
        
        XCTAssertTrue(passwordTextfield.hasKeyboardFocus(), 
                      "Should select next textfield in form on next button tapped"
        )
        passwordTextfield.typeText("access")
        app.keyboards.buttons["fine"].tap()

        XCTAssertFalse((usernameTextfield.hasKeyboardFocus() && passwordTextfield.hasKeyboardFocus()), 
                       "Should unfocus textfields in form on next button tapped from password textfield"
        )

        let spinner = app.windows.otherElements.matching(identifier: "spinner").element
        XCTAssert(spinner.waitForExistence(timeout: 2), "Should show loading spinner")
    }

    func test_initial_view_is_visible_when_login_succeeds() {
        app.signIn(success: true)
        let navigationBar = app.navigationBars.firstMatch.waitForExistence(timeout: 5)
        XCTAssert(navigationBar, "Should show first view with NavigationStack")
    }
    
    func test_error_alert_is_visible_when_login_fails() {
        app.signIn(success: false)
        XCTAssertTrue(
            app.staticTexts["Accesso non riuscito. Hai inserito il nome utente e la password corretti?"]
                .waitForExistence(timeout: 5),
            "Login error should be shown"
        )
    }
}
