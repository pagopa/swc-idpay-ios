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
        case checkmarkDark = "check-filled-dark"
        case checkmark = "check-filled"
        case eye = "eye"
        case warningDark = "warning-dark"
        case warning = "warning"
        case menu = "menu-icon"
        case pending = "pending"
        case toBeRefunded = "toBeRefunded"
        case toBeRefundedDark = "toBeRefunded-dark"
        case refunded = "refunded"
        case info = "info"
        case infoFilled = "info-filled"
        case icoEuro = "euro"
        case checkTic = "checkTic"
    }

    public init (icon: PAIcon) {
        self = Image(icon.rawValue, bundle: .module)
    }
}

