//
//  XCUIApplication+Extensions.swift
//  SWC-iDPay-iOSUITests
//
//  Created by Stefania Castiglioni on 17/01/24.
//

import XCTest

extension XCUIApplication {
        
    func signIn(success: Bool) {
        self.launchEnvironment["-user-login-success"] = success ? "1" : "0"
        self.launch()
        
        let elementsQuery = self.scrollViews.otherElements
        let usernameTextfield = elementsQuery.textFields["Username textfield"]
        XCTAssert(usernameTextfield.waitForExistence(timeout: 6))
        sleep(2)
        XCTAssert(usernameTextfield.hasKeyboardFocus(), "Username textfield should be selected automatically")
        usernameTextfield.typeText("aaa")

        let passwordTextfield = elementsQuery.secureTextFields["Password textfield"]
        passwordTextfield.tap()
        passwordTextfield.typeText("ddd")

        let loginButton = self.buttons["Accedi"]
        loginButton.tap()
    }
    
    func openMenuSection(_ name: String){
        let menuButton = self.navigationBars.firstMatch.buttons["menu-icon"]
        XCTAssert(menuButton.waitForExistence(timeout: 4))
        menuButton.tap()

        let menuItem = self.buttons[name]
        XCTAssert(menuItem.waitForExistence(timeout: 4))
        
        menuItem.tap()
    }
    
    func findRowWithLabelContaining(_ text: String) -> XCUIElement {
        let scrollViewsQuery = self.scrollViews
        let elementsQuery = scrollViewsQuery.otherElements
        let predicate = NSPredicate(format: "label CONTAINS[c] %@", text)
        let button = elementsQuery.buttons.containing(predicate).element
        return button
    }

}
