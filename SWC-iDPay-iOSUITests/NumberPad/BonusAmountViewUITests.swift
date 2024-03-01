//
//  BonusAmountViewUITests.swift
//  SWC-iDPay-iOSUITests
//
//  Created by Stefania Castiglioni on 19/01/24.
//

import XCTest

final class BonusAmountViewUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["-ui-testing"]
        app.openBonusAmountView()
    }

    override func tearDownWithError() throws {
        app = nil
    }
    
    func test_amount_is_correct_when_typing_100() {
        app.buttons["1"].tap()
        app.buttons["00"].tap()
        
        XCTAssert(app.staticTexts["1,00 €"].firstMatch.exists)
    }
    
    func test_amount_is_correct_when_typing_100_and_deleting() {
        app.buttons["1"].tap()
        app.buttons["00"].tap()
        
        XCTAssert(app.staticTexts["1,00 €"].firstMatch.exists)
        
        app.buttons["backspace"].tap()
        XCTAssert(app.staticTexts["0,10 €"].firstMatch.exists)
    }

    func test_amount_is_correct_when_typing_and_deleting_multiple_times() {
        app.buttons["1"].tap()
        app.buttons["2"].tap()
        app.buttons["3"].tap()
        app.buttons["4"].tap()
        app.buttons["00"].tap()
        
        XCTAssert(app.staticTexts["1234,00 €"].firstMatch.exists, "Amount should be 1234,00 €")
        
        app.buttons["backspace"].tap()
        XCTAssert(app.staticTexts["123,40 €"].firstMatch.exists, "Amount should be 123,40 €")
        
        app.buttons["backspace"].tap()
        XCTAssert(app.staticTexts["12,34 €"].firstMatch.exists, "Amount should be 12,34 €")

        app.buttons["backspace"].tap()
        XCTAssert(app.staticTexts["1,23 €"].firstMatch.exists, "Amount should be 1,23 €")

        app.buttons["backspace"].tap()
        XCTAssert(app.staticTexts["0,12 €"].firstMatch.exists, "Amount should be 0,12 €")

        app.buttons["backspace"].tap()
        XCTAssert(app.staticTexts["0,01 €"].firstMatch.exists, "Amount should be 0,01 €")

        app.buttons["backspace"].tap()
        XCTAssert(app.staticTexts["0,00 €"].firstMatch.exists, "Amount should be 0,00 €")

    }

}
