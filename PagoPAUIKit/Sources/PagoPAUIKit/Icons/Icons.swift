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
        case infoFilled = "Info-filled"
        case icoEuro = "euro"
        case checkTic = "checkTic"
        case arrowRight = "arrow-right"
        case pendingDark = "pending-dark"
        case bonus = "bonus"
        case receipt = "receipt"
        case mail = "mail"
        case print = "print"
        case noReceipt = "no-receipt"
        case close = "close"
        case io = "iO"
        case share = "share"
        case transactions = "transactions"
        case faq = "faq"
        case logout = "logout"
        case backspace = "backspace"
        case arrowLeft = "arrow-left"
        case home = "home"
        case chevron = "chevron"
        case cancelled = "cancelled"
    }

    public init (icon: PAIcon) {
        self = Image(icon.rawValue, bundle: .module)
    }
}

