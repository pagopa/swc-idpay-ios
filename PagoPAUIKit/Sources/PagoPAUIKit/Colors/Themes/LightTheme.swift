//
//  File.swift
//  
//
//  Created by Stefania Castiglioni on 23/11/23.
//

import SwiftUI

public struct LightTheme: PagoPATheme {
        
    // MARK: - Background color
    public var backgroundColor: Color = .white
    
    // MARK: - Default icon (ex: for thankyou page)
    public var defaultIcon: Image.PAIcon?

    // MARK: - Toast color
    public var toastBackgroundColor: Color = .turquoiseLight
    public var toastTextBorderBkgColor: Color = .infoDark

    // MARK: - Default buttons background color
    public var primaryButtonBkgColor: Color = .paPrimary
    public var primaryBorderedButtonBkgColor: Color = .clear
    public var secondaryButtonBkgColor: Color = .paPrimaryDark
    public var secondaryBorderedButtonBkgColor: Color = .bluItalia05
    
    // MARK: - Default buttons disabled background color
    public var deafultButtonDisabledBkgColor: Color = .grey200
    public var borderedDisabledButtonBkgColor: Color = .clear

    // MARK: - Buttons text colors
    public var primaryButtonTextColor: Color = .white
    public var primaryBorderedButtonTextColor: Color = .paPrimary
    public var secondaryButtonTextColor: Color = .white
    public var secondaryBorderedButtonTextColor: Color = .paPrimaryDark
    public var plainButtonTextColor: Color = .paPrimary
    
    // MARK: - Button disabled Text colors
    public var defaultButtonDisabledTextColor: Color = .grey700
    public var borderedButtonDisabledTextColor: Color = .grey700

    // MARK: - Disabled button border color
    public var disabledButtonBorderColor: Color = .grey200
    
    // MARK: - Spinner
    public var spinnerPrimaryColor: Color = .white
    public var spinnerSecondaryColor: Color = .paPrimary

    // MARK: - Progress
    public var progressBarBkgColor: Color = .white
    public var progressBarColor: Color = .paPrimary

    // MARK: - Generic texts
    public var titleColor: Color = .blueIODark
    public var subtitleColor: Color = .blueIODark

    
}
