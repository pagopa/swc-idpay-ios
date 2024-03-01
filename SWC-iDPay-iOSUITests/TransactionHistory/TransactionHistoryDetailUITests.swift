//
//  TransactionHistoryDetailUITests.swift
//  SWC-iDPay-iOSUITests
//
//  Created by Stefania Castiglioni on 01/03/24.
//

import XCTest
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
        
    }
}
