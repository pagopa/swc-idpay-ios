//
//  Text+Style.swift
//  
//
//  Created by Stefania Castiglioni on 22/11/23.
//

import SwiftUI

extension Text {
        
    public enum TextStyle {
        case underlined
        case spaced(kerning: CGFloat = 0.5)
    }
    
    /// Underline a Text using the default font and color from PagoPA styleguide
    public func paUnderline() -> Text {
        return self
            .font(.PAFont.linkInline)
            .underline()
            .foregroundColor(.blueIO500)
    }
    
    /// Add font and default style
    public func font(_ font: Font?, style: TextStyle) -> Text {
                
        if let font = font {
            switch style {
            case .underlined:
                return self
                    .font(font)
                    .underline()
                    .foregroundColor(.blueIO500)
            case .spaced(let kerning):
                return self
                    .font(font)
                    .kerning(kerning)
            }
        }
        return self.font(font)
    }
}
