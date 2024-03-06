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
            exp: 1678975089,
            iat: 1678888689,
            n: "tITKOCyhNQ9UC-6yqArtzehjHSlS1prBgHUJI1ngQKvP0O-DI-NSxBhTu5Gbah3hROErrQ-Dhu7ADJNSfuN8sK3OLsTvXHGWX4ZmzFQETyA3UJUwCfV4KFW4Mv0hQHOBJPKcT7CCqTg6pFrxn26mY2RZG4r_pzZex721A9N082rvmRPY11ORg3LBSzJdhrtqza05acdljNoKXaVUcMIHwLilrxEMrR-9U7tgO0gBFvG_thEY0YG8LmeDAdzp8Ub08TWkER_jzUyZpnoJa_KnQ0wpJBOesbnEcmakS_87_oeeEpRCM-Vt1-tszJA4I7QdevD-FuF0NYWylM9JtX5GGnCISdhs8LdYLvVu72tbLWUz0_IpiT8NdTg6EqpwirEGrAudz6scDGLBgUkS9-tw4Rw2vofv86ud94ZQmZFau--oZsoUg2WjUvATv9sE6q5_rxTi1JFYPwpHEwFJHdmOK4OyFXZffgJui-x0n7KhSPjOvgYJz2y9ZVg3v_eLmqC-tvAk4NnG3HzU_l_EzbHWEZgKfFmeSCmb5QcDTU-tUIcXZ0AqyBz0SBX8EK2xAKm8Vo3CGfvTwAUJ8Uz6tUclUn8XF_m2SVsLsp2aDtCstvVM2Oj22RIsmPS7IVGk-8Mh3-4jiQaTtcazZD_nXE-Q6L2I9ZZTwX2mvCZaZtTP0cE",
            keyOps: ["wrapKey"])
    }
}
