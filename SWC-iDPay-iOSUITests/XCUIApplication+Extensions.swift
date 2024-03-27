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

    func openBonusAmountView() {
        self.launchEnvironment = ["-mock-filename": "InitiativesList"]
        self.signIn(success: true)

        let accettaBonusBtn = self.buttons["Accetta bonus ID Pay"].firstMatch
        XCTAssert(accettaBonusBtn.waitForExistence(timeout: 6))
        accettaBonusBtn.tap()
        
        let intiativeItemButton = self.findRowWithLabelContaining("Iniziativa OK").firstMatch
        XCTAssertTrue(intiativeItemButton.waitForExistence(timeout: 4))
        intiativeItemButton.tap()
        
        let amountLabel = self.staticTexts["0,00 €"].firstMatch
        XCTAssert(amountLabel.waitForExistence(timeout: 6))
    }
    
    // History navigation
    func loadMockedHistoryList() {
        self.launchEnvironment = ["-mock-filename": "TransactionsHistoryList"]
        self.signIn(success: true)
        self.openMenuSection("Storico operazioni")
    }
    
    func loadEmptyHistoryList() {
        self.launchEnvironment = ["-empty-state": "1"]
        self.signIn(success: true)
        self.openMenuSection("Storico operazioni")
    }

    // Initiatives navigation
    func loadMockedIntiativesList(empty: Bool = false) {
        if !empty {
            self.launchEnvironment = ["-mock-filename": "InitiativesList"]
        }
        self.signIn(success: true)
        
        let accettaBonusBtn = self.buttons["Accetta bonus ID Pay"].firstMatch
        XCTAssert(accettaBonusBtn.waitForExistence(timeout: 6))
        accettaBonusBtn.tap()
    }
    
    func loadInitiativesList() {
        let accettaBonusBtn = self.buttons["Accetta bonus ID Pay"].firstMatch
        XCTAssert(accettaBonusBtn.waitForExistence(timeout: 6))
        accettaBonusBtn.tap()
    }
    
    func selectOkInitiative() {
        let intiativeItemButton = self.findRowWithLabelContaining("Iniziativa OK").firstMatch
        XCTAssertTrue(intiativeItemButton.waitForExistence(timeout: 4))
        intiativeItemButton.tap()
    }
    
    func insertAmount() {
        let amountLabel = self.staticTexts["0,00 €"].firstMatch
        XCTAssert(amountLabel.waitForExistence(timeout: 6))

        self.buttons["5"].tap()
        self.buttons["00"].tap()
        
        XCTAssert(self.staticTexts["5,00 €"].firstMatch.exists)
        let confirmBtn = self.buttons["Conferma"]
        XCTAssertTrue(confirmBtn.isHittable)
        confirmBtn.tap()
    }
    
    func authorizeWithCie() {
        let authorizeWithCIEBtn = self.buttons["Identificazione con CIE"]
        XCTAssertTrue(authorizeWithCIEBtn.waitForExistence(timeout: 4))
        authorizeWithCIEBtn.tap()
        
        XCTAssertTrue(self.staticTexts["Appoggia la CIE sul dispositivo, in alto"].waitForExistence(timeout: 2))
    }
    
    func insertPin() {
        XCTAssertTrue(self.staticTexts["Inserisci il codice ID Pay"].waitForExistence(timeout: 2))
        let oneNumberBtn = self.buttons["1"]
        oneNumberBtn.tap()
        oneNumberBtn.tap()
        oneNumberBtn.tap()
        
        // test should insert at least 4 numbers
        let confirmPinBtn = self.buttons["Conferma"]
        XCTAssertFalse(confirmPinBtn.isEnabled)
        
        oneNumberBtn.tap()
        XCTAssertTrue(confirmPinBtn.isEnabled)
        confirmPinBtn.tap()
    }
}
