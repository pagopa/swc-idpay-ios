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
    
    static var mockedSuccessResponse: Self {
        VerifyCIEResponse(
            kty: "RSA",
            e: "AQAB",
            use: "enc",
            kid: "0ffa8f8d-d92b-46ee-a4e7-8f26651a2a96",
            exp: 1792403695,
            iat: 1706003695,
            n: "s5nlBwPCCWmp5DeXnOZIvHAkVxQ5uTLV0kmooPm8oWPi1ZAUWc03uOggBcknifv6219iiI83DQapMIOBfc2VJLDVC0QNLPzHvP8ifZlqMVLijp8CLDfruVXzPVqvlrXzVVjJM+dqBSVJlODI18+QNUWiYP2vHYo29t8hQne/dJEVQx9q+wFCE5j5hfLiB+Ms9twJgfIDYXmAYllWqY+vxL2gNs16N9TRA1JyxApNgJBbxb17z/ijEZKkqs/+eGsi/OtQA1v4uooM1XR1YswsspF1V5d+srCC9fX9+hQTIMUsB/XcTepABx36f7/10jOFPG2FMWroGUNAF9wneNpgQD8zNwXMwf85ElDp2k3BlqFcCTbNAXsFtIKHpI2GRbwLZoosfFqN3dB+3eRAIAkXBtIrzPVGdEg32Ob2DPirDU/KA3D776NCjD/fTyFpgApMkGMXkUFa3X5LMwIJBEvhy37lkLVdHz8j+CKUIPQrU1r4/UgnfY82wO7EyY5QoTtA3vU45VQs8DN4ObBHFOIrsAVYBlDagdnqKC0lIMlcTc6B+x9HwgTQS0X/YjdI3i/JcM2jA45IOZADr5iBLCVnDxOZYyPXImNR+GzAMQjcWpaGhNLzGl6FteaVx6WH250vmecvpTJo7/djB9/3GNnsInq0p4ptS2AKupN7vTIIXV0=",
            keyOps: ["wrapKey"])
    }
}
