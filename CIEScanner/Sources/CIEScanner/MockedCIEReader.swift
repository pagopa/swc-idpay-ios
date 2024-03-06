//
//  MockedCIEReader.swift
//
//
//  Created by Stefania Castiglioni on 06/03/24.
//

import Foundation

public class MockedCIEReader: NSObject, CIEReadable {
    
    public func scan(challenge: String) async throws -> NisAuthenticated? {
        try? await Task.sleep(nanoseconds: 1 * 2_000_000_000)
        return NisAuthenticated.mocked
    }
}
