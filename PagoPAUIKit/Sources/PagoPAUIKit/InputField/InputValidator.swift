//
//  InputValidator.swift
//
//
//  Created by Stefania Castiglioni on 13/12/23.
//

import SwiftUI

public enum RuleType {
    case otp
    case email
    case requiredText
    case requiredLength(Int, InputType)
    
    var maxLength: Int? {
        switch self {
        case .otp:
            return 18
        case .requiredLength(let length, _):
            return length
        default:
            return nil
        }
    }
    
    var pattern: String? {
        switch self {
        case .otp:
            return "^(\\d){18}$"
        case .email:
            return "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        case .requiredText:
            return "^(\\w)+"
        case .requiredLength(let length, let inputType):
            if inputType == .number {
                return "^(\\d){\(length)}$"
            }
            return "^(\\w){\(length)}$"
        }
    }
    
    var errorDescription: String {
        switch self {
        case .otp:
            return "OTP must be 18 chars"
        case .email:
            return "Invalid email"
        case .requiredText:
            return "Field is required"
        case .requiredLength(let length, _):
            return "Field must be \(length) chars"
        }
    }
}

extension InputField {
    
    func validateField(rule: RuleType) -> Bool {
        if let pattern = rule.pattern {
            let textWithoutSpaces = text.replacingOccurrences(of: " ", with: "")
            let result = textWithoutSpaces.range(of: pattern, options: .regularExpression)
            return result != nil
        }
        return true
    }
}
