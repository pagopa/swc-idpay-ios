//
//  NisAuthenticated.swift
//
//
//  Created by Stefania Castiglioni on 30/01/24.
//

import Foundation

public struct NisAuthenticated {
    public var nis: String
    public var kpubIntServ: String
    public var haskKpubIntServ: String
    public var sod: String
    public var challengeSigned: String
    
    public func toString() -> String {
        return "----- NIS Authenticated: ------\n" + 
        "----- nis: -----\n \(nis)\n" +
        "---- sod: -----\n \(sod)\n" +
        "---- kpubIntServ: ----\n\(kpubIntServ)\n" +
        "---- challengeSigned: ----\n\(challengeSigned)"
    }
}

public extension NisAuthenticated {
    static var mocked: Self {
        return NisAuthenticated(
            nis: "912934523673",
            kpubIntServ: "fakeKeyPub",
            haskKpubIntServ: "fakeHash",
            sod: "fakeSod",
            challengeSigned: "fakeChallengeSigned")
    }
}
