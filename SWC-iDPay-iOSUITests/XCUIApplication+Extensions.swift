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
        
        sleep(4)
        let elementsQuery = self.scrollViews.otherElements
        let usernameTextfield = elementsQuery.textFields["Username textfield"]
        usernameTextfield.tap()
        usernameTextfield.typeText("aaa")

        let passwordTextfield = elementsQuery.secureTextFields["Password textfield"]
        passwordTextfield.tap()
        passwordTextfield.typeText("ddd")

        let loginButton = self.buttons["Accedi"]
        loginButton.tap()
    }
}
