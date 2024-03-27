//
//  QRCodeUITests.swift
//  SWC-iDPay-iOSUITests
//
//  Created by Stefania Castiglioni on 25/03/24.
//

import XCTest
@testable import SWC_iDPay_iOS

final class QRCodeUITests: XCTestCase {

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

    func test_authorize_with_qr_code() {
        app.launchEnvironment = [
            "-mock-filename": "InitiativesList",
            "-qrcode-ok": "1"]
        app.signIn(success: true)
        
        app.loadInitiativesList()
        app.selectOkInitiative()
        app.insertAmount()
        app.authorizeWithQrCode()
        
        XCTAssertTrue(app.staticTexts["Attendi autorizzazione"].waitForExistence(timeout: 2))
        
        // Test success flow ok
        app.successPaymentConfirm()
    }
    
    func test_qrcode_help_dialog_is_visible_when_tapping_on_help_btn() {
        
        app.launchEnvironment = [
            "-mock-filename": "InitiativesList",
            "-qrcode-help": "1"]
        app.signIn(success: true)
        
        app.loadInitiativesList()
        app.selectOkInitiative()
        app.insertAmount()
        app.authorizeWithQrCode()
        
        app.buttons["Problemi con il QR?"].tap()
        
        XCTAssertTrue(app.staticTexts["Problemi con il QR?"].exists)
        XCTAssertTrue(app.staticTexts["Entra sull’app IO, vai nella sezione Inquadra e digita il codice:"].exists)
        let closeBtn = app.buttons["close"]
        closeBtn.tap()
        XCTAssertTrue(app.buttons["Problemi con il QR?"].isHittable)
    }
    
    func test_qrcode_session_expired_when_max_retries_exceeded() {
        app.launchEnvironment = [
            "-mock-filename": "InitiativesList",
            "-polling-max-retries-exceeded": "1"]
        app.signIn(success: true)
        
        app.loadInitiativesList()
        app.selectOkInitiative()
        app.insertAmount()
        app.authorizeWithQrCode()
        
        XCTAssertTrue(app.staticTexts["La sessione è scaduta"].waitForExistence(timeout: 4))
        app.buttons["Riprova"].tap()
        XCTAssertTrue(app.staticTexts["Inquadra il codice QR con il tuo smartphone"].waitForExistence(timeout: 4))
        
        XCTAssertTrue(app.staticTexts["La sessione è scaduta"].waitForExistence(timeout: 6))
        app.buttons["Accetta nuovo bonus"].tap()
        XCTAssertTrue(app.staticTexts["Scegli l'iniziativa"].waitForExistence(timeout: 4))
    }
    
    func test_qrcode_canceled_transaction() {
        app.launchEnvironment = [
            "-mock-filename": "InitiativesList",
            "-qrcode-canceled": "1"]
        app.signIn(success: true)
        
        app.loadInitiativesList()
        app.selectOkInitiative()
        app.insertAmount()
        app.authorizeWithQrCode()

        XCTAssertTrue(app.staticTexts["L'operazione è stata annullata"].waitForExistence(timeout: 4))
        
        // Accept new bonus
        let acceptNewBonusBtn = app.buttons["Accetta nuovo bonus"]
        XCTAssertTrue(acceptNewBonusBtn.exists)
        acceptNewBonusBtn.tap()
        
        XCTAssertTrue(app.staticTexts["Scegli l'iniziativa"].waitForExistence(timeout: 4))
    }
    
    func test_qrcode_canceled_transaction_retry() {
        app.launchEnvironment = [
            "-mock-filename": "InitiativesList",
            "-qrcode-canceled": "1"]
        app.signIn(success: true)
        
        app.loadInitiativesList()
        app.selectOkInitiative()
        app.insertAmount()
        app.authorizeWithQrCode()

        XCTAssertTrue(app.staticTexts["L'operazione è stata annullata"].waitForExistence(timeout: 4))
        
        let retryBtn = app.buttons["Riprova"]
        retryBtn.tap()
        XCTAssertTrue(app.staticTexts["Inquadra il codice QR con il tuo smartphone"].waitForExistence(timeout: 4))
    }

    func test_cancel_qrcode_transaction_during_polling_when_authorized() {
        app.launchEnvironment = [
            "-mock-filename": "InitiativesList",
            "-qrcode-canceled-during-polling": "1"]
        app.signIn(success: true)
        
        app.loadInitiativesList()
        app.selectOkInitiative()
        app.insertAmount()
        app.authorizeWithQrCode()

        XCTAssertTrue(app.staticTexts["Attendi autorizzazione"].waitForExistence(timeout: 1))
        app.buttons["Annulla"].tap()
        XCTAssertTrue(app.staticTexts["Vuoi annullare la spesa del bonus ID Pay?"].waitForExistence(timeout: 1))
        XCTAssertTrue(app.staticTexts["Se annulli l’operazione,l’importo verrà riaccreditato sull’iniziativa del cittadino."].waitForExistence(timeout: 1))

        app.buttons["Annulla operazione"].tap()
        XCTAssertTrue(app.staticTexts["Operazione annullata"].waitForExistence(timeout: 1))
        XCTAssertTrue(app.staticTexts["L'importo autorizzato è stato riaccreditato sull'iniziativa del cittadino."].exists)
        app.buttons["Continua"].tap()

        XCTAssertTrue(app.staticTexts["Serve la ricevuta?"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.staticTexts["Puoi riemettere la ricevuta in un momento successivo dalla sezione ‘Storico operazioni’."].exists)
        app.buttons["No, grazie"].tap()

        XCTAssertTrue(app.staticTexts["Operazione conclusa"].exists)

        // Accept new bonus
        app.buttons["Accetta nuovo bonus"].tap()
        XCTAssertTrue(app.staticTexts["Scegli l'iniziativa"].exists)

    }
    
    func test_qrcode_rejected_transaction() {
        app.launchEnvironment = [
            "-mock-filename": "InitiativesList",
            "-qrcode-rejected": "1"]
        app.signIn(success: true)
        
        app.loadInitiativesList()
        app.selectOkInitiative()
        app.insertAmount()
        app.authorizeWithQrCode()

        XCTAssertTrue(app.staticTexts["Autorizzazione negata"].waitForExistence(timeout: 4))
        XCTAssertTrue(app.staticTexts["Non è stato addebitato alcun importo."].exists)
        XCTAssertTrue(app.images["toBeRefunded-dark"].exists)

        app.buttons["Accetta nuovo bonus"].tap()
        XCTAssertTrue(app.staticTexts["Scegli l'iniziativa"].waitForExistence(timeout: 4))
    }
    
    func test_home_btn_shows_cancel_confirm_alert_and_loads_home() {
        app.launchEnvironment = [
            "-mock-filename": "InitiativesList",
            "-qrcode-load-home": "1"]
        app.signIn(success: true)
        
        app.loadInitiativesList()
        app.selectOkInitiative()
        app.insertAmount()
        app.authorizeWithQrCode()

        // Tap home button and close popup
        let homeButton = app.navigationBars.firstMatch.buttons["home"]
        XCTAssertTrue(homeButton.waitForExistence(timeout: 4))

        homeButton.tap()
        XCTAssertTrue(app.staticTexts["Vuoi uscire dall’operazione in corso?"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.staticTexts["L’operazione verrà annullata e sarà necessario ricominciare da capo."].waitForExistence(timeout: 2))
        app.buttons["Annulla"].tap()
        XCTAssertTrue(app.staticTexts["Inquadra il codice QR con il tuo smartphone"].waitForExistence(timeout: 4))
        
        // Tap home button and load home
        homeButton.tap()
        XCTAssertTrue(app.staticTexts["Vuoi uscire dall’operazione in corso?"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.staticTexts["L’operazione verrà annullata e sarà necessario ricominciare da capo."].waitForExistence(timeout: 2))
        app.buttons["Esci dal pagamento"].tap()
        XCTAssert(app.buttons["Accetta bonus ID Pay"].waitForExistence(timeout: 6))
    }
    
    func test_qrcode_polling_error() {
        app.launchEnvironment = [
            "-mock-filename": "InitiativesList",
            "-qrcode-polling-error": "1"]
        app.signIn(success: true)
        
        app.loadInitiativesList()
        app.selectOkInitiative()
        app.insertAmount()
        app.authorizeWithQrCode()

        let okBtn = app.buttons["Ok, ho capito"]
        XCTAssertTrue(okBtn.waitForExistence(timeout: 2))
        okBtn.tap()
        XCTAssertTrue(app.staticTexts["Inquadra il codice QR con il tuo smartphone"].exists)
    }
}
