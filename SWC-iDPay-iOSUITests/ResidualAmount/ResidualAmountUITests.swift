//
//  ResidualAmountUITests.swift
//  SWC-iDPay-iOSUITests
//
//  Created by Stefania Castiglioni on 21/03/24.
//

import XCTest
@testable import SWC_iDPay_iOS

final class ResidualAmountUITests: XCTestCase {

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
    
    func test_residual_amount_cash_payment() {
        app.launchEnvironment = [
            "-mock-filename": "InitiativesList",
            "-cie-reading-success": "1",
            "-residual-amount": "1"]
        app.signIn(success: true)
        
        app.loadInitiativesList()
        app.selectOkInitiative()
        app.insertAmount()
        app.authorizeWithCie()
        
        // Transaction detail
        XCTAssertTrue(app.staticTexts["Confermi l'operazione?"].waitForExistence(timeout: 10))
        app.buttons["Conferma"].tap()

        // Confirm transaction with pin
        app.insertPin()
        
        // Receipt is visible
        let predicate = NSPredicate(format: "label CONTAINS 'Hai pagato'")
        XCTAssertTrue(app.staticTexts.containing(predicate).element.waitForExistence(timeout: 2))

        app.buttons["Continua"].tap()
        let notNowBtn = app.buttons["No, grazie"]
        XCTAssertTrue(notNowBtn.exists)

        // Proceed without receipt
        notNowBtn.tap()
        XCTAssertTrue(app.staticTexts["Operazione conclusa"].exists)
        XCTAssertTrue(app.staticTexts["Puoi riemettere la ricevuta in un momento successivo dalla sezione ‘Storico operazioni’."].exists)
        
        XCTAssertTrue(app.staticTexts["C'è un importo residuo"].waitForExistence(timeout: 3))
        
        // Pay residual amount
        let residualPaymentBtn = app.buttons["Paga l'importo residuo"].firstMatch
        XCTAssertTrue(residualPaymentBtn.exists)
        residualPaymentBtn.tap()
        XCTAssertTrue(app.staticTexts["Pagamento residuo"].waitForExistence(timeout: 2))

        let payPredicate = NSPredicate(format: "label CONTAINS 'Paga'")
        let payBtn = app.buttons.containing(payPredicate).element
        XCTAssertTrue(payBtn.waitForExistence(timeout: 2))
        payBtn.tap()
        XCTAssertTrue(app.staticTexts["Prosegui con il pagamento del residuo in contanti"].waitForExistence(timeout: 2))

        let acceptNewBonusBtn = app.buttons["Accetta nuovo bonus"]
        XCTAssertTrue(acceptNewBonusBtn.exists)
        acceptNewBonusBtn.tap()
        XCTAssertTrue(app.staticTexts["Scegli l'iniziativa"].waitForExistence(timeout: 2))

    }
}
