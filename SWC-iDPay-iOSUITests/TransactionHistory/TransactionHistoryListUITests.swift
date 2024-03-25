//
//  TransactionHistoryListUITests.swift
//  SWC-iDPay-iOSUITests
//
//  Created by Stefania Castiglioni on 28/02/24.
//

import XCTest
@testable import SWC_iDPay_iOS

final class TransactionHistoryListUITests: XCTestCase {

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

    func test_history_list_loads_when_transactions_are_loaded() {
        app.signIn(success: true)
        app.openMenuSection("Storico operazioni")
        XCTAssertTrue(app.staticTexts["Aspetta qualche istante"].exists)
        
        let app = XCUIApplication()
        let elementsQuery = app.scrollViews.otherElements
        XCTAssertTrue(elementsQuery.staticTexts["Storico operazioni"].waitForExistence(timeout: 2.0))
    }
    
    func test_history_list_item_icon_is_checkmark_when_status_is_authorized() {
        app.loadMockedHistoryList()
        XCTAssertTrue(app.staticTexts["Aspetta qualche istante"].exists)

        let authorizedItemButton = app.findRowWithLabelContaining("BonusOK")
        XCTAssertTrue(authorizedItemButton.waitForExistence(timeout: 4))
        XCTAssertTrue(authorizedItemButton.images["check-filled"].exists)
    }
    
    func test_history_list_item_authorized_detail_is_open_when_tapping_on_authorized_row() {
        app.loadMockedHistoryList()
        XCTAssertTrue(app.staticTexts["Aspetta qualche istante"].waitForExistence(timeout: 2))
                
        let authorizedItemButton = app.findRowWithLabelContaining("BonusOK").firstMatch
        XCTAssertTrue(authorizedItemButton.waitForExistence(timeout: 4))
        authorizedItemButton.tap()
        
        let authorizedStatusLabel = app.scrollViews.otherElements.staticTexts["ESEGUITA"]
        XCTAssertTrue(authorizedStatusLabel.waitForExistence(timeout: 2))
    }

    func test_history_list_item_icon_is_cancelled_when_status_is_cancelled() {
        app.loadMockedHistoryList()
        XCTAssertTrue(app.staticTexts["Aspetta qualche istante"].exists)
                
        let cancelledItemButton = app.findRowWithLabelContaining("BonusCancelled").firstMatch
        XCTAssertTrue(cancelledItemButton.waitForExistence(timeout: 4))
        XCTAssertTrue(cancelledItemButton.images["cancelled"].exists)
    }
    
    func test_history_list_item_cancelled_detail_is_open_when_tapping_on_cancelled_row() {
        app.loadMockedHistoryList()
        XCTAssertTrue(app.staticTexts["Aspetta qualche istante"].exists)
                
        let cancelledItemButton = app.findRowWithLabelContaining("BonusCancelled").firstMatch
        XCTAssertTrue(cancelledItemButton.waitForExistence(timeout: 4))
        cancelledItemButton.tap()
        
        let cancelledStatusLabel = app.scrollViews.otherElements.staticTexts["ANNULLATA"]
        XCTAssertTrue(cancelledStatusLabel.waitForExistence(timeout: 2))
    }
    
    func test_history_list_is_empty_when_no_transaction_is_fetched() {
        app.loadEmptyHistoryList()
        
        XCTAssertTrue(app.staticTexts["Non ci sono operazioni"].waitForExistence(timeout: 4))
    }
    
    func test_history_list_help_view_is_visible_when_help_button_is_tapped() {
        app.loadEmptyHistoryList()
        
        let helpButton = app.buttons["Vai all'assistenza"]
        XCTAssertTrue(helpButton.waitForExistence(timeout: 4))
        helpButton.tap()
        
        XCTAssertTrue(app.navigationBars.firstMatch.staticTexts["Assistenza"].waitForExistence(timeout: 4))
    }
}
