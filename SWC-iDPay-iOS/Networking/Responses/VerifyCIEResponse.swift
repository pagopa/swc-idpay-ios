//
//  VerifyCIEResponse.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 14/02/24.
//

import Foundation

struct VerifyCIEResponse: Decodable {
    
    var kty: String
    var e: String
    var use: String
    var kid: String
    var exp: Int32
    var iat: Int32
    var n: String
    var keyOps: [String]?

}

extension VerifyCIEResponse {
    
    static var mocked: Self {
        VerifyCIEResponse(
            kty: "RSA",
            e: "AQAB",
            use: "enc",
            kid: "0ffa8f8d-d92b-46ee-a4e7-8f26651a2a96",
            exp: 1678975089,
            iat: 1678888689,
            n: """
                    qjcVEWJTTySeKxHsJSsmVGk2cEvXJ4tBC4uyU5MxYwBAiIWuZb_
                    yDOIjLz7JN8QsJs3QrZtS3vqv18ljW2db6ED90OUo9CVJveSF4eNRozDHOvnHGT0HR-
                    8Wf5GxcNy63zfQLrnfdp5F9TrhMFRMkEA0TCT7PhT3yF6YvwLtQyMciER1_KKnpGomfAkW-
                    UpaF2nHfXiFPrOIHMuNb5BoRR1f0349tqloLgLd7vyMy1jg-
                    BldmEgRV1bcFqjH0Cg3leROjDy9HzdFauRIlSb4VZrqNni2hgaTUHI5Xp7aCwpS9Y_
                    mf19KpxN0_8d-f3UVRlwtI1dryelpdC5jowxia2Pf8UgSZyMs2ZxDf6eU0SH8wHEvMpeFpwmiBD1XcsISoTan0Yv7w_
                    CLo6JOqX6EfogDQZUBzKKlVCZSoSinAz0_7Bj2orgWKQ9sbfgJWgJweKkJLH-bNSRaVcu02boxPnlJeay3wROhSAgtiKWZnsU1_
                    FpPNG0JBFCh_x-VjkuBoREpNEyJM5NvhRCmyObtzocS4eCtAgvmo3EFv_Xa-rp0p5ez4A-_
                    QUb5OsYOswqYbIV1GbtiAfCTOrNbv6K86LaTllZ9WqYrKgDv7KA-604K37k33LHROqcO9Q-bCN8hKzQDWs7M3DFNP6P5iBUUVs-
                    gtWncHvIuUWTth-fBXa8
                """,
            keyOps: ["wrapKey"]
        )
    }
}
