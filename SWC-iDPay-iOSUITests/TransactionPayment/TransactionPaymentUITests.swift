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

    func test_payment_successfull_when_authorizing_with_cie() {
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
                
        XCTAssertTrue(app.staticTexts["Confermi l'operazione?"].waitForExistence(timeout: 10))
        app.buttons["Conferma"].tap()
        XCTAssertTrue(app.staticTexts["Inserisci il codice ID Pay"].waitForExistence(timeout: 2))
        let oneNumberBtn = app.buttons["1"]
        oneNumberBtn.tap()
        oneNumberBtn.tap()
        oneNumberBtn.tap()
        
        // test should insert at least 4 numbers
        let confirmPinBtn = app.buttons["Conferma"]
        XCTAssertFalse(confirmPinBtn.isEnabled)
        
        oneNumberBtn.tap()
        XCTAssertTrue(confirmPinBtn.isEnabled)
        confirmPinBtn.tap()
        
        let predicate = NSPredicate(format: "label CONTAINS 'Hai pagato'")
        XCTAssertTrue(app.staticTexts.containing(predicate).element.waitForExistence(timeout: 2))

        app.buttons["Continua"].tap()
        XCTAssertTrue(app.staticTexts["Serve la ricevuta?"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.staticTexts["Puoi riemettere la ricevuta in un momento successivo dalla sezione ‘Storico operazioni’."].exists)
        XCTAssertTrue(app.buttons["Invia via e-mail"].exists)
        XCTAssertTrue(app.buttons["Condividi"].exists)
        let notNowBtn = app.buttons["No, grazie"]
        XCTAssertTrue(notNowBtn.exists)

        notNowBtn.tap()
        XCTAssertTrue(app.staticTexts["Operazione conclusa"].exists)
        XCTAssertTrue(app.staticTexts["Puoi riemettere la ricevuta in un momento successivo dalla sezione ‘Storico operazioni’."].exists)
        
        let acceptNewBonusBtn = app.buttons["Accetta nuovo bonus"]
        XCTAssertTrue(acceptNewBonusBtn.exists)
        acceptNewBonusBtn.tap()
        
        XCTAssertTrue(app.staticTexts["Scegli l'iniziativa"].exists)
    }
}
