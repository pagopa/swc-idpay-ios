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
        
        loadInitiativesList()
        selectOkInitiative()
        insertAmount()
        authorizeWithCie()
        
        // Transaction detail
        XCTAssertTrue(app.staticTexts["Confermi l'operazione?"].waitForExistence(timeout: 10))
        app.buttons["Conferma"].tap()

        // Confirm transaction with pin
        insertPin()
        
        // Receipt is visible
        let predicate = NSPredicate(format: "label CONTAINS 'Hai pagato'")
        XCTAssertTrue(app.staticTexts.containing(predicate).element.waitForExistence(timeout: 2))

        app.buttons["Continua"].tap()
        XCTAssertTrue(app.staticTexts["Serve la ricevuta?"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.staticTexts["Puoi riemettere la ricevuta in un momento successivo dalla sezione ‘Storico operazioni’."].exists)
        XCTAssertTrue(app.buttons["Invia via e-mail"].exists)
        XCTAssertTrue(app.buttons["Condividi"].exists)
        let notNowBtn = app.buttons["No, grazie"]
        XCTAssertTrue(notNowBtn.exists)

        // Proceed without receipt
        notNowBtn.tap()
        XCTAssertTrue(app.staticTexts["Operazione conclusa"].exists)
        XCTAssertTrue(app.staticTexts["Puoi riemettere la ricevuta in un momento successivo dalla sezione ‘Storico operazioni’."].exists)
        
        // Accept new bonus
        let acceptNewBonusBtn = app.buttons["Accetta nuovo bonus"]
        XCTAssertTrue(acceptNewBonusBtn.exists)
        acceptNewBonusBtn.tap()
        
        XCTAssertTrue(app.staticTexts["Scegli l'iniziativa"].exists)
    }
    
    func test_deleted_alert_is_shown_on_deny_transaction() {
        app.launchEnvironment = [
            "-mock-filename": "InitiativesList",
            "-cie-reading-success": "1",
            "-transaction-delete-success": "1"]
        app.signIn(success: true)
        
        loadInitiativesList()
        selectOkInitiative()
        insertAmount()
        authorizeWithCie()
        
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
        
        loadInitiativesList()
        selectOkInitiative()
        insertAmount()
        authorizeWithCie()
        
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
        
        loadInitiativesList()
        selectOkInitiative()
        insertAmount()
        authorizeWithCie()
        
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
        
        loadInitiativesList()
        selectOkInitiative()
        insertAmount()
        authorizeWithCie()

        XCTAssertTrue(app.staticTexts["La sessione è scaduta"].waitForExistence(timeout: 6))
        app.buttons["Riprova"].tap()
        XCTAssertTrue(app.staticTexts["Appoggia la CIE sul dispositivo, in alto"].waitForExistence(timeout: 4))
    }
    
    func test_error_page_is_shown_when_verifyCie_fails() {
        app.launchEnvironment = [
            "-mock-filename": "InitiativesList",
            "-cie-reading-success": "0"]
        app.signIn(success: true)
        
        loadInitiativesList()
        selectOkInitiative()
        insertAmount()
        authorizeWithCie()
        XCTAssertTrue(app.staticTexts["Si è verificato un errore imprevisto"].waitForExistence(timeout: 6))
        XCTAssertTrue(app.buttons["Autorizza con"].exists)
        XCTAssertTrue(app.buttons["Accetta nuovo bonus"].exists)

    }
}

extension TransactionPaymentUITests {
    
    func loadInitiativesList() {
        let accettaBonusBtn = app.buttons["Accetta bonus ID Pay"].firstMatch
        XCTAssert(accettaBonusBtn.waitForExistence(timeout: 6))
        accettaBonusBtn.tap()
    }
    
    func selectOkInitiative() {
        let intiativeItemButton = app.findRowWithLabelContaining("Iniziativa OK").firstMatch
        XCTAssertTrue(intiativeItemButton.waitForExistence(timeout: 4))
        intiativeItemButton.tap()
    }
    
    func insertAmount() {
        let amountLabel = app.staticTexts["0,00 €"].firstMatch
        XCTAssert(amountLabel.waitForExistence(timeout: 6))

        app.buttons["5"].tap()
        app.buttons["00"].tap()
        
        XCTAssert(app.staticTexts["5,00 €"].firstMatch.exists)
        let confirmBtn = app.buttons["Conferma"]
        XCTAssertTrue(confirmBtn.isHittable)
        confirmBtn.tap()
    }
    
    func authorizeWithCie() {
        let authorizeWithCIEBtn = app.buttons["Identificazione con CIE"]
        XCTAssertTrue(authorizeWithCIEBtn.waitForExistence(timeout: 4))
        authorizeWithCIEBtn.tap()
        
        XCTAssertTrue(app.staticTexts["Appoggia la CIE sul dispositivo, in alto"].waitForExistence(timeout: 2))
    }
    
    func insertPin() {
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
    }
}
