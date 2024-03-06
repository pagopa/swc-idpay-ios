//
//  TransactionHistoryDetailUITests.swift
//  SWC-iDPay-iOSUITests
//
//  Created by Stefania Castiglioni on 01/03/24.
//

import XCTest
import Foundation
@testable import SWC_iDPay_iOS

final class TransactionHistoryDetailUITests: XCTestCase {

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

    func test_delete_btn_is_visible_when_transaction_is_recent() {
        app.loadMockedHistoryList()
        XCTAssertTrue(app.staticTexts["Aspetta qualche istante"].exists)
                
        let authorizedItemButton = app.findRowWithLabelContaining("BonusOK").firstMatch
        XCTAssertTrue(authorizedItemButton.waitForExistence(timeout: 4))
        authorizedItemButton.tap()
        
        let authorizedStatusLabel = app.scrollViews.otherElements.staticTexts["ESEGUITA"]
        XCTAssertTrue(authorizedStatusLabel.waitForExistence(timeout: 2))
        
        XCTAssertTrue(app.buttons["Annulla operazione"].waitForExistence(timeout: 3))
    }
    
    func test_delete_btn_is_not_visible_when_transaction_is_too_old() {
        app.loadMockedHistoryList()
        
        let fourDaysAgoDate = Calendar.current.date(byAdding: .day, value: -4, to: Date())
        XCTAssertNotNil(fourDaysAgoDate, "Cannot build date for checks on non deletable transaction")

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM yyyy, HH:mm"
        let dateFormatted = dateFormatter.string(from: fourDaysAgoDate!)

        let authorizedItemButton = app.findRowWithLabelContaining(dateFormatted)
        XCTAssertTrue(authorizedItemButton.waitForExistence(timeout: 4))
        authorizedItemButton.tap()
        
        let authorizedStatusLabel = app.scrollViews.otherElements.staticTexts["ESEGUITA"]
        XCTAssertTrue(authorizedStatusLabel.waitForExistence(timeout: 2))
        
        XCTAssertFalse(app.buttons["Annulla operazione"].waitForExistence(timeout: 3))
    }
    
    func test_delete_transaction_flow_without_receipt_going_home() {
        self.deleteTransaction()

        XCTAssertTrue(app.staticTexts["Operazione annullata"].waitForExistence(timeout: 5))
        
        let confirmButton = app.buttons["Continua"]
        XCTAssertTrue(confirmButton.waitForExistence(timeout: 2.0), "Button \"Continua\" not found")
        confirmButton.tap()

        XCTAssertTrue(app.staticTexts["Serve la ricevuta?"].waitForExistence(timeout: 2))

        let noThanks = app.buttons["No, grazie"]
        XCTAssertTrue(noThanks.waitForExistence(timeout: 2.0), "Button \"No, grazie\" not found")
        noThanks.tap()
        
        XCTAssertTrue(app.staticTexts["Operazione conclusa"].waitForExistence(timeout: 2))

        let goHomeButton = app.buttons["Torna alla home"]
        goHomeButton.tap()
        XCTAssertTrue(app.staticTexts["Accetta un bonus ID Pay"].waitForExistence(timeout: 2))
    }
    
    func test_delete_transaction_cancel() {
        app.loadMockedHistoryList()
        XCTAssertTrue(app.staticTexts["Aspetta qualche istante"].exists)
                
        let authorizedItemButton = app.findRowWithLabelContaining("BonusOK").firstMatch
        XCTAssertTrue(authorizedItemButton.waitForExistence(timeout: 4))
        authorizedItemButton.tap()
        
        let authorizedStatusLabel = app.scrollViews.otherElements.staticTexts["ESEGUITA"]
        XCTAssertTrue(authorizedStatusLabel.waitForExistence(timeout: 2))
        
        let deleteBtn = app.buttons["Annulla operazione"]
        XCTAssertTrue(deleteBtn.waitForExistence(timeout: 3))
        deleteBtn.tap()
                
        XCTAssertTrue(app.staticTexts["Vuoi annullare la spesa del bonus ID Pay?"].waitForExistence(timeout: 5))
        
        let deleteBtns = app.buttons.matching(identifier: "dialog")
        
        if deleteBtns.count > 0 {
            let backBtn = deleteBtns.element(boundBy: 0)
            backBtn.tap()
        }
        
        XCTAssertTrue(app.staticTexts["Dettaglio operazione"].exists)
        XCTAssertFalse(app.staticTexts["Serve la ricevuta?"].exists)
    }
    
    func test_transaction_receipt_sharing_view_is_visible() {
        app.loadMockedHistoryList()
                                        
        let authorizedItemButton = app.findRowWithLabelContaining("BonusOK").firstMatch
        XCTAssertTrue(authorizedItemButton.waitForExistence(timeout: 4))
        authorizedItemButton.tap()
        
        let authorizedStatusLabel = app.scrollViews.otherElements.staticTexts["ESEGUITA"]
        XCTAssertTrue(authorizedStatusLabel.waitForExistence(timeout: 2))
        
        let receiptBtn = app.buttons["Emetti ricevuta"]
        XCTAssertTrue(receiptBtn.waitForExistence(timeout: 3))
        receiptBtn.tap()
        
        XCTAssertTrue(app.staticTexts["Serve la ricevuta?"].exists)
        let shareBtn = app.buttons["Condividi"]
        XCTAssertTrue(shareBtn.exists)
        shareBtn.tap()

        let activity = app.scrollViews.otherElements["receipt, PDF Document"]
        let closeBtn = app.navigationBars.buttons["Close"]
        XCTAssertTrue(closeBtn.waitForExistence(timeout: 4))
        closeBtn.tap()
        
        XCTAssertTrue(app.staticTexts["Operazione conclusa"].waitForExistence(timeout: 2))

        let goHomeButton = app.buttons["Torna alla home"]
        goHomeButton.tap()
        XCTAssertTrue(app.staticTexts["Accetta un bonus ID Pay"].waitForExistence(timeout: 2))

    }

}

extension TransactionHistoryDetailUITests {
    
    func deleteTransaction() {
        app.loadMockedHistoryList()
                
        let authorizedItemButton = app.findRowWithLabelContaining("BonusOK").firstMatch
        XCTAssertTrue(authorizedItemButton.waitForExistence(timeout: 4))
        authorizedItemButton.tap()
        
        let authorizedStatusLabel = app.scrollViews.otherElements.staticTexts["ESEGUITA"]
        XCTAssertTrue(authorizedStatusLabel.waitForExistence(timeout: 2))
        
        let deleteBtn = app.buttons["Annulla operazione"]
        XCTAssertTrue(deleteBtn.waitForExistence(timeout: 3))
        deleteBtn.tap()
                
        XCTAssertTrue(app.staticTexts["Vuoi annullare la spesa del bonus ID Pay?"].waitForExistence(timeout: 5))
        
        let deleteBtns = app.buttons.matching(identifier: "dialog")
        
        if deleteBtns.count > 0 {
            let confirmDeleteBtn = deleteBtns.element(boundBy: 1)
            confirmDeleteBtn.tap()
        }
        
    }
}
