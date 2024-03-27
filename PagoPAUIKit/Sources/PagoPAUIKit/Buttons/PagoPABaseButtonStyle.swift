//
//  PagoPABaseButtonStyle.swift
//  
//
//  Created by Stefania Castiglioni on 22/11/23.
//

import SwiftUI

public enum PagoPAButtonType {
    case primary
    case primaryBordered
    case secondary
    case secondaryBordered
    case plain
}

/**
 Button model to create a custom pagoPAButtonStyle
 
 - parameter type: type of button.
 - parameter theme: reference theme for color style
 - parameter icon: icon to show inside the button
 - parameter iconPosition: icon positioning on button
 
 - # Example #
 ```
  ButtonModel(type: .primary, theme: .dark, icon: .star, iconPosition: .left)
 ```
 
 */
public struct ButtonModel: Identifiable {
    
    public var id = UUID()
    var type: PagoPAButtonType
    var themeType: ThemeType
    var title: String
    var icon: Image.PAIcon?
    var iconPosition: ImagePosition?
    var action: () -> Void
    
    public init(type: PagoPAButtonType, themeType: ThemeType, title: String, icon: Image.PAIcon? = nil, iconPosition: ImagePosition? = nil, action: @escaping () -> Void) {
        self.type = type
        self.title = title
        self.themeType = themeType
        self.icon = icon
        self.iconPosition = iconPosition
        self.action = action
    }
}

struct PagoPABaseButtonStyle: ButtonStyle {

    @Environment(\.isEnabled) private var isEnabled
    
    private var buttonType: PagoPAButtonType
    private var fullwidth: Bool
    private var theme: PagoPATheme
    private var paImage: Image?
    private var position: ImagePosition = .right

    private var isBordered: Bool {
        return buttonType == .primaryBordered || buttonType == .secondaryBordered
    }
    
    public init(buttonModel: ButtonModel, fullwidth: Bool = true){
        self.buttonType = buttonModel.type
        self.fullwidth = fullwidth
        self.theme      = ThemeManager.buildTheme(type: buttonModel.themeType)
        
        if let icon = buttonModel.icon {
            self.paImage    = Image(icon: icon)
        }
        self.position   = buttonModel.iconPosition ?? .right
    }
    
    public init(buttonType: PagoPAButtonType, fullwidth: Bool = true, icon: Image.PAIcon? = nil, position: ImagePosition = .right, themeType: ThemeType = .light) {
        self.buttonType = buttonType
        self.theme      = ThemeManager.buildTheme(type: themeType)
        self.fullwidth = fullwidth
        
        if let icon = icon {
            self.paImage    = Image(icon: icon)
        }
        self.position   = position
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        
        if fullwidth {
            buttonStack(configuration: configuration)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: Constants.radius1)
                        .fill(isEnabled ? backgroundColor : disabledBackgroundColor)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: Constants.radius1)
                        .stroke(isBordered ? (isEnabled ? borderColor : disabledBorderColor) : Color.clear, lineWidth: 2)
                )
                .opacity(isEnabled ? 1 : 0.5)
                .contentShape(Rectangle())
        } else {
            buttonStack(configuration: configuration)
                .padding(.horizontal, Constants.mediumSpacing)
                .background(
                    RoundedRectangle(cornerRadius: Constants.radius1)
                        .fill(isEnabled ? backgroundColor : disabledBackgroundColor)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: Constants.radius1)
                        .stroke(isBordered ? (isEnabled ? borderColor : disabledBorderColor) : Color.clear, lineWidth: 2)
                )
                .opacity(isEnabled ? 1 : 0.5)
                .contentShape(Rectangle())
        }
    }
    
    private func buttonStack(configuration: Configuration) -> some View {
        HStack(alignment: .center, spacing: 8) {
            if position == .left {
                icon
            }
            
            configuration.label
                .padding(.vertical, Constants.smallSpacing)
            
            if position == .right {
                icon
            }

        }
        .font(.PAFont.cta)
        .foregroundColor(isEnabled ? textColor : disabledTextColor)
    }
        
    @ViewBuilder
    private var icon: some View {
        if let paImage = paImage {
            paImage
                .resizable()
                .scaledToFit()
                .foregroundColor(isEnabled ? textColor : disabledTextColor)
                .frame(height: Constants.buttonIconSize)
        } else {
            EmptyView()
        }
    }
    
    // MARK: - Background
    private var backgroundColor: Color {
        switch buttonType {
        case .primary:
            return theme.primaryButtonBkgColor
        case .primaryBordered:
            return theme.primaryBorderedButtonBkgColor
        case .secondary:
            return theme.secondaryButtonBkgColor
        case .secondaryBordered:
            return theme.secondaryBorderedButtonBkgColor
        case .plain:
            return .clear
        }
    }
    
    private var disabledBackgroundColor: Color {
        
        switch buttonType {
        case .primaryBordered, .secondaryBordered:
            return theme.borderedDisabledButtonBkgColor
        default:
            return theme.deafultButtonDisabledBkgColor
        }

    }

    // MARK: - Foreground
    private var textColor: Color {
        switch buttonType {
        case .primary:
            return theme.primaryButtonTextColor
        case .primaryBordered:
            return theme.primaryBorderedButtonTextColor
        case .secondary:
            return theme.secondaryButtonTextColor
        case .secondaryBordered:
            return theme.secondaryBorderedButtonTextColor
        case .plain:
            return theme.plainButtonTextColor
        }
    }
    
    private var disabledTextColor: Color {
        switch buttonType {
        case .primaryBordered, .secondaryBordered:
            return theme.borderedButtonDisabledTextColor
        default:
            return theme.defaultButtonDisabledTextColor
        }
    }
    
    // MARK: - Border
    private var borderColor: Color {
        return textColor
    }

    private var disabledBorderColor: Color {
        return theme.disabledButtonBorderColor
    }

}

