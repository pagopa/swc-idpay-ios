//
//  UITestingHelper.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 16/01/24.
//

import Foundation

struct UITestingHelper {
    
    static var isUITesting: Bool {
        ProcessInfo.processInfo.arguments.contains("-ui-testing")
    }
    
    static var isUserLoginSuccess: Bool {
        ProcessInfo.processInfo.environment["-user-login-success"] == "1"
    }
    
    static var isEmptyStateTest: Bool {
        ProcessInfo.processInfo.environment["-empty-state"] == "1"
    }
    
    static var isMaxRetriesTest: Bool {
        ProcessInfo.processInfo.environment["-polling-max-retries-exceeded"] == "1"
    }
    
    static func containsInputOption(_ string: String) -> Bool {
       ProcessInfo.processInfo.environment[string] != nil
    }
    
    static func isTrue(_ string: String) -> Bool {
        guard let option = ProcessInfo.processInfo.environment[string], option == "1" else {
            return false
        }
        return true
    }
    
    static func getMockedObject<T: Decodable>(jsonName: String) throws -> T? {
        guard let path = Bundle.main.path(forResource: jsonName, ofType: "json"),
              let data = try? NSData(contentsOfFile: path, options: .mappedIfSafe) else {
            return nil
        }
        return try JSONDecoder().decode(T.self, from: data as Data)
    }
 
    static func isSessionExpiredTesting(scope: String? = nil) -> Bool {
        let sessionExpiredOption = (scope != nil) ? "-refresh-token-\(scope!)-success" : "-refresh-token-success"
        guard
            let refreshTokenOpt = ProcessInfo.processInfo.environment[sessionExpiredOption],
                refreshTokenOpt == "0" else {
            return false
        }
        return true
    }
}
