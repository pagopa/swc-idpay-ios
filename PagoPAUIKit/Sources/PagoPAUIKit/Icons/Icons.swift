//
//  Icons.swift
//  
//
//  Created by Stefania Castiglioni on 23/11/23.
//

import SwiftUI

extension Image {
    
    public enum PAIcon: String {
        case star = "star"
        case idPayLogo = "id-pay-logo"
        case lock = "lock"
        case checkmark = "check-filled"
        case eye = "eye"
        case warning = "warning"
        case menu = "menu-icon"
        case pending = "pending"
        case toBeRefunded = "toBeRefunded"
        case refunded = "refunded"
    }

    public init (icon: PAIcon) {
        self = Image(icon.rawValue, bundle: .module)
    }
}

