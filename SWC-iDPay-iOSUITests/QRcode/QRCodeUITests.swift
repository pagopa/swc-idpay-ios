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
        
        XCTAssertTrue(app.staticTexts["Attendi autorizzazione"].waitForExistence(timeout: 1))
        XCTAssertTrue(app.staticTexts["Per proseguire è necessario autorizzare l’operazione sull’app IO"].waitForExistence(timeout: 1))
        
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
        
        let qrCodeHelpBtn = app.buttons["Problemi con il QR?"]
        XCTAssertTrue(qrCodeHelpBtn.exists)
        qrCodeHelpBtn.tap()
        
        XCTAssertTrue(app.staticTexts["Problemi con il QR?"].exists)
        XCTAssertTrue(app.staticTexts["Entra sull’app IO, vai nella sezione Inquadra e digita il codice:"].exists)
        let closeBtn = app.buttons["close"]
        closeBtn.tap()
        XCTAssertTrue(qrCodeHelpBtn.isHittable)
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

}
