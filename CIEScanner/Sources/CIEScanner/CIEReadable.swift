//
//  CIEReadable.swift
//
//
//  Created by Stefania Castiglioni on 06/03/24.
//

import Foundation

public protocol CIEReadable where Self: NSObject {
    func scan(challenge: String) async throws -> NisAuthenticated?
}
