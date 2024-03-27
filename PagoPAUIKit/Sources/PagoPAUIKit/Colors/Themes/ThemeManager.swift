//
//  ThemeManager.swift
//  
//
//  Created by Stefania Castiglioni on 28/11/23.
//

import Foundation

public enum ThemeType {
    case light, dark, error, success, info, warning
}

public struct ThemeManager {
    
    public static func buildTheme(type: ThemeType) -> PagoPATheme {
        switch type {
        case .dark:
            return DarkTheme()
        case .light:
            return LightTheme()
        case .success:
            return SuccessTheme()
        case .error:
            return ErrorTheme()
        case .info:
            return InfoTheme()
        case .warning:
            return WarningTheme()
        }
    }
}
