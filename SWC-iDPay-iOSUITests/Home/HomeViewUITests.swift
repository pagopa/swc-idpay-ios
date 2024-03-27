//
//  HomeViewUITests.swift
//  SWC-iDPay-iOSUITests
//
//  Created by Stefania Castiglioni on 27/02/24.
//

import XCTest
@testable import SWC_iDPay_iOS

final class HomeViewUITests: XCTestCase {

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
    
    func test_home_animation() {
        app.signIn(success: true)

        let homeLogo = app.images["bonus"]
        XCTAssertFalse(homeLogo.exists)

        // Logo loaded after 1.5 secs
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            XCTAssertTrue(homeLogo.exists)
        }
        
        // Title loaded after 1.5 secs
        let acceptBonusLabel = app.staticTexts["Accetta un bonus ID Pay"]
        XCTAssertFalse(acceptBonusLabel.exists)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            XCTAssertTrue(acceptBonusLabel.exists)
        }
        
        // Button loaded after 1.5 secs
        let acceptBonusBtn = app.buttons["Accetta bonus ID Pay"]
        XCTAssertFalse(acceptBonusBtn.exists)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            XCTAssertTrue(acceptBonusBtn.exists)
        }
    }
    
    func test_accept_bonus_redirect_is_working() {
        app.signIn(success: true)

        let acceptBonusBtn = app.buttons["Accetta bonus ID Pay"]
        XCTAssertTrue(acceptBonusBtn.waitForExistence(timeout: 8.0))
        acceptBonusBtn.tap()

        XCTAssertTrue(app.staticTexts["Nessuna iniziativa trovata"].waitForExistence(timeout: 4.0))
    }
    
    func test_auth_token_expired_renews_successfully() {
        app.launchEnvironment = [
            "-refresh-token-success": "1"
        ]
        app.signIn(success: true)
        let acceptBonusBtn = app.buttons["Accetta bonus ID Pay"]
        XCTAssertTrue(acceptBonusBtn.waitForExistence(timeout: 8.0))

        XCUIDevice.shared.press(.home)
        XCUIApplication().activate()
        XCTAssertTrue(app.staticTexts["Stiamo verificando la sessione..."].waitForExistence(timeout: 3))
        XCTAssertFalse(app.staticTexts["Sessione scaduta"].waitForExistence(timeout: 2))
        XCTAssertTrue(acceptBonusBtn.exists)

    }
    
    func test_session_expired() {
        app.launchEnvironment = [
            "-refresh-token-success": "0"
        ]
        app.signIn(success: true)
        XCTAssertTrue(app.buttons["Accetta bonus ID Pay"].waitForExistence(timeout: 8.0))

        XCUIDevice.shared.press(.home)
        XCUIApplication().activate()
        XCTAssertTrue(app.staticTexts["Stiamo verificando la sessione..."].waitForExistence(timeout: 3))
        XCTAssertTrue(app.staticTexts["Sessione scaduta"].waitForExistence(timeout: 3))
        XCTAssertTrue(app.staticTexts["Accedi nuovamente all'app."].exists)

        app.buttons["Accedi"].tap()
        XCTAssert(app.scrollViews.otherElements.textFields["Username textfield"].waitForExistence(timeout: 2))
    }

}
