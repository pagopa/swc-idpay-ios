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
        
        app.loadInitiativesList()
        app.selectOkInitiative()
        app.insertAmount()
        app.authorizeWithCie()
        
        // Transaction detail
        XCTAssertTrue(app.staticTexts["Confermi l'operazione?"].waitForExistence(timeout: 10))
        app.buttons["Conferma"].tap()

        // Confirm transaction with pin
        app.insertPin()
        
        // Test success flow ok
        app.successPaymentConfirm()
    }
    
    func test_deleted_alert_is_shown_on_deny_transaction() {
        app.launchEnvironment = [
            "-mock-filename": "InitiativesList",
            "-cie-reading-success": "1",
            "-transaction-delete-success": "1"]
        app.signIn(success: true)
        
        app.loadInitiativesList()
        app.selectOkInitiative()
        app.insertAmount()
        app.authorizeWithCie()
        
        // Deny transaction
        XCTAssertTrue(app.staticTexts["Confermi l'operazione?"].waitForExistence(timeout: 10))
        app.buttons["Nega"].tap()
        
        // Transaction successfully denied
        XCTAssertTrue(app.staticTexts["L'operazione è stata annullata"].waitForExistence(timeout: 6))
    }
    
    func test_retry_after_transaction_delete_shows_cie_reading() {
        app.launchEnvironment = [
            "-mock-filename": "InitiativesList",
            "-cie-reading-success": "1",
            "-transaction-delete-success": "1"]
        app.signIn(success: true)
        
        app.loadInitiativesList()
        app.selectOkInitiative()
        app.insertAmount()
        app.authorizeWithCie()
        
        // Deny transaction
        XCTAssertTrue(app.staticTexts["Confermi l'operazione?"].waitForExistence(timeout: 4))
        app.buttons["Nega"].tap()
        XCTAssertTrue(app.staticTexts["L'operazione è stata annullata"].waitForExistence(timeout: 4))
        
        app.buttons["Riprova"].tap()
        XCTAssertTrue(app.staticTexts["Appoggia la CIE sul dispositivo, in alto"].waitForExistence(timeout: 4))
    }

    func test_home_button_tap_on_transaction_detail_asks_for_delete() {
        app.launchEnvironment = [
            "-mock-filename": "InitiativesList",
            "-cie-reading-success": "1"]
        app.signIn(success: true)
        
        app.loadInitiativesList()
        app.selectOkInitiative()
        app.insertAmount()
        app.authorizeWithCie()
        
        XCTAssertTrue(app.staticTexts["Confermi l'operazione?"].waitForExistence(timeout: 4))
        // Tap home button and close popup
        let homeButton = app.navigationBars.firstMatch.buttons["home"]
        XCTAssertTrue(homeButton.waitForExistence(timeout: 4))

        homeButton.tap()
        XCTAssertTrue(app.staticTexts["Vuoi uscire dall’operazione in corso?"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.staticTexts["L’operazione verrà annullata e sarà necessario ricominciare da capo."].waitForExistence(timeout: 2))
        app.buttons["Annulla"].tap()
        XCTAssertTrue(app.staticTexts["Confermi l'operazione?"].waitForExistence(timeout: 4))
        
        // Tap home button and load home
        homeButton.tap()
        XCTAssertTrue(app.staticTexts["Vuoi uscire dall’operazione in corso?"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.staticTexts["L’operazione verrà annullata e sarà necessario ricominciare da capo."].waitForExistence(timeout: 2))
        app.buttons["Esci dal pagamento"].tap()
        XCTAssert(app.buttons["Accetta bonus ID Pay"].waitForExistence(timeout: 6))
        
    }
    
    func test_session_expired_is_shown_on_polling_transaction_status_max_retries_exceeded() {
        app.launchEnvironment = [
            "-mock-filename": "InitiativesList",
            "-cie-reading-success": "1",
            "-polling-max-retries-exceeded": "1"]
        app.signIn(success: true)
        
        app.loadInitiativesList()
        app.selectOkInitiative()
        app.insertAmount()
        app.authorizeWithCie()

        XCTAssertTrue(app.staticTexts["La sessione è scaduta"].waitForExistence(timeout: 6))
        app.buttons["Riprova"].tap()
        XCTAssertTrue(app.staticTexts["Appoggia la CIE sul dispositivo, in alto"].waitForExistence(timeout: 4))
    }
    
    func test_error_dialog_is_shown_when_verifyCie_fails() {
        app.launchEnvironment = [
            "-mock-filename": "InitiativesList",
            "-cie-reading-success": "0"]
        app.signIn(success: true)
        
        app.loadInitiativesList()
        app.selectOkInitiative()
        app.insertAmount()
        app.authorizeWithCie()
        
        XCTAssertTrue(app.staticTexts["Si è verificato un errore imprevisto"].waitForExistence(timeout: 6))
        app.buttons["Ok, ho capito"].tap()
        XCTAssertTrue(app.staticTexts["Appoggia la CIE sul dispositivo, in alto"].waitForExistence(timeout: 4))
    }
}
