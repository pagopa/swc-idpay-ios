//
//  SessionExpiredUITests.swift
//  SWC-iDPay-iOSUITests
//
//  Created by Stefania Castiglioni on 28/03/24.
//

import XCTest
@testable import SWC_iDPay_iOS

final class SessionExpiredUITests: XCTestCase {

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
    
    func test_session_expired_on_initiatives_list() {
        app.launchEnvironment = ["-refresh-token-initiatives-success": "0"]
        app.signIn(success: true)
        let acceptBonusBtn = app.buttons["Accetta bonus ID Pay"]
        XCTAssertTrue(acceptBonusBtn.waitForExistence(timeout: 6.0))
        acceptBonusBtn.tap()
        
        checkSessionExpiredDialogIsWorking()
    }

    func test_session_expired_on_history() {
        app.launchEnvironment = ["-refresh-token-history-success": "0"]
        app.signIn(success: true)
        app.openMenuSection("Storico operazioni")
        
        checkSessionExpiredDialogIsWorking()
    }

    func test_session_expired_on_create_transaction() {
        app.launchEnvironment = [
            "-refresh-token-create-success": "0",
            "-mock-filename": "InitiativesList"]
        app.signIn(success: true)
        app.loadInitiativesList()
        app.selectOkInitiative()
        app.insertAmount()

        checkSessionExpiredDialogIsWorking()
    }

    func test_session_expired_on_verify_cie() {
        app.launchEnvironment = [
            "-refresh-token-verify-cie-success": "0",
            "-mock-filename": "InitiativesList"]
        app.signIn(success: true)
        app.loadInitiativesList()
        app.selectOkInitiative()
        app.insertAmount()
        app.authorizeWithCie()

        checkSessionExpiredDialogIsWorking()
    }

    func test_session_expired_on_cie_polling_status() {
        app.launchEnvironment = [
            "-refresh-token-polling-success": "0",
            "-mock-filename": "InitiativesList"]
        app.signIn(success: true)
        app.loadInitiativesList()
        app.selectOkInitiative()
        app.insertAmount()
        app.authorizeWithCie()

        checkSessionExpiredDialogIsWorking()
    }
    
    func test_session_expired_on_qrcode_polling_status() {
        app.launchEnvironment = [
            "-refresh-token-polling-success": "0",
            "-mock-filename": "InitiativesList"]
        app.signIn(success: true)
        app.loadInitiativesList()
        app.selectOkInitiative()
        app.insertAmount()
        app.authorizeWithQrCode()

        checkSessionExpiredDialogIsWorking()
    }

}

extension SessionExpiredUITests {
    
    func checkSessionExpiredDialogIsWorking() {
        XCTAssertTrue(app.staticTexts["Sessione scaduta"].waitForExistence(timeout: 4))
        XCTAssertTrue(app.staticTexts["Accedi nuovamente all'app."].exists)

        app.buttons["Accedi"].tap()
        XCTAssert(app.scrollViews.otherElements.textFields["Username textfield"].waitForExistence(timeout: 2))
    }
}
