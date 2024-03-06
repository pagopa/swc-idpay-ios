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
        XCTAssertTrue(app.staticTexts["Aspetta qualche istante"].exists)
        XCTAssertTrue(app.staticTexts["Scegli l'iniziativa"].waitForExistence(timeout: 4))
        
        app.buttons["Iniziativa OK"].tap()
        XCTAssertTrue(app.staticTexts["IMPORTO DEL BENE"].exists, "Bonus amount not loaded on tap on initiative row")
    }
    
    func test_empty_state_view_is_visible_when_initiatives_list_is_empty() {
        app.loadMockedIntiativesList(empty: true)
        XCTAssertTrue(app.staticTexts["Aspetta qualche istante"].exists)
        XCTAssertTrue(app.staticTexts["Non ci sono iniziative attive"].waitForExistence(timeout: 4))
        
        app.buttons["Riprova"].tap()
        XCTAssertTrue(app.staticTexts["Aspetta qualche istante"].exists)
        XCTAssertTrue(app.staticTexts["Non ci sono iniziative attive"].waitForExistence(timeout: 4))
    }
}
