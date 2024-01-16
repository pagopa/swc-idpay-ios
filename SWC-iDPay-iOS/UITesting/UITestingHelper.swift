//
//  UITestingHelper.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 16/01/24.
//

#if DEBUG
import Foundation

struct UITestingHelper {
    
    static var isUITesting: Bool {
        ProcessInfo.processInfo.arguments.contains("-ui-testing")
    }

    static var isUserLoginSuccess: Bool {
        ProcessInfo.processInfo.environment["-user-login-success"] == "1"
    }
}

#endif
