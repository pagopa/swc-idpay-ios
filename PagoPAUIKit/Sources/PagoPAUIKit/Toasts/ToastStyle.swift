//
//  ToastStyle.swift
//
//
//  Created by Pier Domenico Bonamassa on 13/12/23.
//

import SwiftUI

public enum ToastStyle: CaseIterable {
    case neutralIcon
    case neutral
    case error
    case warning
    case success
    case infoFilled
    
    var theme: PagoPATheme {
        switch self {
        case .neutral, .neutralIcon:
            return LightTheme()
        case .error:
            return ErrorTheme()
        case .warning:
            return WarningTheme()
        case .success:
            return SuccessTheme()
        case .infoFilled:
            return InfoTheme()
        }
    }
    
    var icon: Image.PAIcon? {
        switch self {
        case .neutralIcon:
            return .checkTic
        case .neutral:
            return nil
        case .error:
            return .warningDark
        case .warning:
            return .toBeRefundedDark
        case .success:
            return .checkmarkDark
        case .infoFilled:
            return .infoFilled
        }
    }
}
