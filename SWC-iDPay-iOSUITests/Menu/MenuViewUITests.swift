//
//  MenuViewUITests.swift
//  SWC-iDPay-iOSUITests
//
//  Created by Stefania Castiglioni on 17/01/24.
//

import XCTest
@testable import SWC_iDPay_iOS

final class MenuViewUITests: XCTestCase {

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
    
    func test_open_menu_when_hamburger_menu_is_tapped() {
        app.signIn(success: true)
        
        let menuButton = app.navigationBars.firstMatch.buttons["menu-icon"]
        XCTAssert(menuButton.waitForExistence(timeout: 4))
        menuButton.tap()
        
        let firstMenuItem = app.buttons["Accetta un bonus ID Pay"]
        XCTAssert(firstMenuItem.waitForExistence(timeout: 4))
    }
    
    func test_close_menu_when_bonus_menu_item_is_tapped() {
        app.signIn(success: true)
        
        let menuButton = app.navigationBars.firstMatch.buttons["menu-icon"]
        XCTAssert(menuButton.waitForExistence(timeout: 4))
        menuButton.tap()
        
        let menuItem = app.buttons["Storico operazioni"]
        XCTAssert(menuItem.waitForExistence(timeout: 4))
        
        menuItem.tap()
        sleep(2)
        let menuExists = app.buttons["Storico operazioni"].exists
        XCTAssertFalse(menuExists)
    }

    func test_close_menu_when_transaction_menu_item_is_tapped() {
        app.signIn(success: true)
        
        let menuButton = app.navigationBars.firstMatch.buttons["menu-icon"]
        XCTAssert(menuButton.waitForExistence(timeout: 4))
        menuButton.tap()
        
        let menuItem = app.buttons["Storico operazioni"]
        XCTAssert(menuItem.waitForExistence(timeout: 4))
        
        menuItem.tap()
        sleep(2)
        let menuItemExists = app.buttons["Storico operazioni"].exists
        XCTAssertFalse(menuItemExists)
    }

    func test_close_menu_when_faq_menu_item_is_tapped() {
        app.signIn(success: true)
        
        let menuButton = app.navigationBars.firstMatch.buttons["menu-icon"]
        XCTAssert(menuButton.waitForExistence(timeout: 4))
        menuButton.tap()
        
        let menuItem = app.buttons["Assistenza"]
        XCTAssert(menuItem.waitForExistence(timeout: 4))
        
        menuItem.tap()
        sleep(2)
        let menuItemExists = app.buttons["Assistenza"].exists
        XCTAssertFalse(menuItemExists)
    }

    func test_close_menu_when_exit_menu_item_is_tapped() {
        app.signIn(success: true)
        
        let menuButton = app.navigationBars.firstMatch.buttons["menu-icon"]
        XCTAssert(menuButton.waitForExistence(timeout: 4))
        menuButton.tap()
        
        let menuItem = app.buttons["Esci"]
        XCTAssert(menuItem.waitForExistence(timeout: 4))
        
        menuItem.tap()
        sleep(2)
        let menuItemExists = app.buttons["Esci"].exists
        XCTAssertFalse(menuItemExists)
    }
}
