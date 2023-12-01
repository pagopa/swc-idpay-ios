//
//  ColorsTests.swift
//  
//
//  Created by Stefania Castiglioni on 21/11/23.
//

import XCTest
import SwiftUI
@testable import PagoPAUIKit

// Demo tests to check Colors implementation
final class ColorsTests: XCTestCase {

    func test_primaryColor() throws {
        let primaryColor = Color("Primary")
        XCTAssertEqual(primaryColor, Color.paPrimary)
    }

    func test_blackColor() throws {
        let blackColor = Color("Black")
        XCTAssertEqual(blackColor, Color.paBlack)
    }
}
