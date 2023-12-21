//
//  DarkTheme.swift
//  
//
//  Created by Stefania Castiglioni on 23/11/23.
//

import SwiftUI

public struct DarkTheme: PagoPATheme {
    
    // MARK: - Toast color
    public var toastBackgroundColor: Color = .turquoiseLight
    public var toastTextBorderBkgColor: Color = .infoDark
    
    // MARK: - Background color
    public var backgroundColor: Color = .paPrimary
    
    // MARK: - Default icon (ex: for thankyou page)
    public var defaultIcon: Image.PAIcon? = nil
    
    // MARK: - Default buttons background color
    public var primaryButtonBkgColor: Color = .white
    public var primaryBorderedButtonBkgColor: Color = .clear
    public var secondaryButtonBkgColor: Color = .bluItalia50
    public var secondaryBorderedButtonBkgColor: Color = .paPrimaryDark
    
    // MARK: - Default buttons disabled background color
    public var deafultButtonDisabledBkgColor: Color = .grey200
    public var borderedDisabledButtonBkgColor: Color = .paPrimaryDark

    // MARK: - Buttons text colors
    public var primaryButtonTextColor: Color = .paPrimary
    public var primaryBorderedButtonTextColor: Color = .white
    public var secondaryButtonTextColor: Color = .paPrimaryDark
    public var secondaryBorderedButtonTextColor: Color = .white
    public var plainButtonTextColor: Color = .white

    // MARK: - Button disabled Text colors
    public var defaultButtonDisabledTextColor: Color = .grey700
    public var borderedButtonDisabledTextColor: Color = .blueBorder

    // MARK: - Disabled button border color
    public var disabledButtonBorderColor: Color = .blueBorder
    
    // MARK: - Spinner
    public var spinnerPrimaryColor: Color = .paPrimary
    public var spinnerSecondaryColor: Color = .white
    
    // MARK: - Progress
    public var progressBarBkgColor: Color = .white
    public var progressBarColor: Color = .paPrimary

    // MARK: - Generic texts
    public var titleColor: Color = .white
    public var subtitleColor: Color = .white

}

