//
//  TransactionPaymentUITests.swift
//  SWC-iDPay-iOSUITests
//
//  Created by Stefania Castiglioni on 06/03/24.
//

import XCTest
@testable import SWC_iDPay_iOS

final class TransactionPaymentUITests: XCTestCase {

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

    func test_cie_reading_view_is_visible_when_authorizing_with_cie() {
        app.launchEnvironment = [
            "-mock-filename": "InitiativesList",
            "-cie-reading-success": "1"]
        
        app.signIn(success: true)

        let accettaBonusBtn = app.buttons["Accetta bonus ID Pay"].firstMatch
        XCTAssert(accettaBonusBtn.waitForExistence(timeout: 6))
        accettaBonusBtn.tap()
        
        let intiativeItemButton = app.findRowWithLabelContaining("Iniziativa OK").firstMatch
        XCTAssertTrue(intiativeItemButton.waitForExistence(timeout: 4))
        intiativeItemButton.tap()
        
        let amountLabel = app.staticTexts["0,00 €"].firstMatch
        XCTAssert(amountLabel.waitForExistence(timeout: 6))

        app.buttons["5"].tap()
        app.buttons["00"].tap()
        
        XCTAssert(app.staticTexts["5,00 €"].firstMatch.exists)
        let confirmBtn = app.buttons["Conferma"]
        XCTAssertTrue(confirmBtn.isHittable)
        confirmBtn.tap()
        
        let authorizeWithCIEBtn = app.buttons["Identificazione con CIE"]
        XCTAssertTrue(authorizeWithCIEBtn.waitForExistence(timeout: 4))
        authorizeWithCIEBtn.tap()
        
        XCTAssertTrue(app.staticTexts["Appoggia la CIE sul dispositivo, in alto"].waitForExistence(timeout: 2))
//        XCTAssertTrue(app.staticTexts["Pronto per la lettura"].waitForExistence(timeout: 4))

    }
}
