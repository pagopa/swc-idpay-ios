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
    
    static func getMockedObject<T: Decodable>(jsonName: String) -> T? {
        guard let path = Bundle.main.path(forResource: jsonName, ofType: "json"),
              let data = try? NSData(contentsOfFile: path, options: .mappedIfSafe) else {
            return nil
        }
        return try? JSONDecoder().decode(T.self, from: data as Data)
    }
    
}
#endif
