//
//  InputType.swift
//  
//
//  Created by Stefania Castiglioni on 13/12/23.
//

import SwiftUI

public enum InputType {
    case password
    case text
    case number
    
    var icon: Image.PAIcon? {
        return nil
        
        switch self {
        case .text, .password:
            return nil
        case .number:
            return .lock
        }
    }
    
    var keyboardType: UIKeyboardType {
        switch self {
        case .number:
            return .numberPad
        default:
            return .default
        }
    }
    
    var chunkStep: Int? {
        switch self {
        case .number:
            return 4
        default:
            return nil
        }
    }
}
