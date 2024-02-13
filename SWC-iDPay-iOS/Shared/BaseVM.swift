//
//  BaseVM.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 13/02/24.
//

import Foundation

class BaseVM: ObservableObject {
    var networkClient: Requestable
    
    init(networkClient: Requestable) {
        self.networkClient = networkClient
    }
}

