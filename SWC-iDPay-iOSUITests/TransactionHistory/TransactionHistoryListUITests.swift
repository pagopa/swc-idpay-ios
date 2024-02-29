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
        app.launchEnvironment = ["-mocked-history": "TransactionsHistoryList"]
        app.signIn(success: true)
        app.openMenuSection("Storico operazioni")
        XCTAssertTrue(app.staticTexts["Aspetta qualche istante"].exists)

        let rowItems = app.buttons["historyRowItem"]
        let firstRow = rowItems.firstMatch
        XCTAssertEqual(firstRow.label, "check-filled")
    }
}
