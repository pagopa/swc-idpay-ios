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
    
}
