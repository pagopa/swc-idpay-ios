//
//  InitiativesListUITests.swift
//  SWC-iDPay-iOSUITests
//
//  Created by Stefania Castiglioni on 06/03/24.
//

import XCTest
@testable import SWC_iDPay_iOS

final class InitiativesListUITests: XCTestCase {

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
    
    func test_initiatives_list_when_initiatives_are_loaded() {
        app.loadMockedIntiativesList()
        XCTAssertTrue(app.staticTexts["Attendi qualche istante"].exists)
        XCTAssertTrue(app.staticTexts["Scegli l'iniziativa"].waitForExistence(timeout: 4))
        
        app.buttons["Iniziativa OK"].tap()
        XCTAssertTrue(app.staticTexts["IMPORTO DEL BENE"].exists, "Bonus amount not loaded on tap on initiative row")
    }
    
    func test_empty_state_view_is_visible_when_initiatives_list_is_empty() {
        app.loadMockedIntiativesList(empty: true)
        XCTAssertTrue(app.staticTexts["Attendi qualche istante"].exists)
        XCTAssertTrue(app.staticTexts["Nessuna iniziativa trovata"].waitForExistence(timeout: 4))
        
        let helpButton = app.buttons["Vai all'assistenza"]

        XCTAssertTrue(helpButton.waitForExistence(timeout: 4))
        helpButton.tap()
        
        XCTAssertTrue(app.navigationBars.firstMatch.staticTexts["Assistenza"].waitForExistence(timeout: 4))
    }
    
    func test_initiatives_list_when_service_fails() {
        app.launchEnvironment = ["-initiative-list-error": "1"]
        app.signIn(success: true)
        
        app.loadInitiativesList()
        XCTAssertTrue(app.staticTexts["Attendi qualche istante"].exists)
        XCTAssertTrue(app.staticTexts["Non è stato possibile recuperare la lista delle iniziative"].waitForExistence(timeout: 4))
        
        let homeButton = app.buttons["Torna alla home"]
        XCTAssertTrue(homeButton.waitForExistence(timeout: 4))
        homeButton.tap()
        XCTAssertTrue(app.staticTexts["Accetta un bonus ID Pay"].waitForExistence(timeout: 4))
    }
}
