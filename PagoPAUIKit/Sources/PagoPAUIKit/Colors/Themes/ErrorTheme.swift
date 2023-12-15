//
//  File.swift
//  
//
//  Created by Stefania Castiglioni on 23/11/23.
//

import SwiftUI

public struct ErrorTheme: PagoPATheme {
        
    // MARK: - Background color
    public var backgroundColor: Color = .errorLight
    
    // MARK: - Default icon (ex: for thankyou page)
    public var defaultIcon: Image.PAIcon? = .warningDark

    // MARK: - Toast color
    public var toastBackgroundColor: Color = .errorLight
    public var toastTextBorderBkgColor: Color = .errorDark

    // MARK: - Default buttons background color
    public var primaryButtonBkgColor: Color = .errorDark
    public var primaryBorderedButtonBkgColor: Color = .clear
    public var secondaryButtonBkgColor: Color = .errorGraphic
    public var secondaryBorderedButtonBkgColor: Color = .clear
    
    // MARK: - Default buttons disabled background color
    public var deafultButtonDisabledBkgColor: Color = .grey200
    public var borderedDisabledButtonBkgColor: Color = .clear

    // MARK: - Buttons text colors
    public var primaryButtonTextColor: Color = .white
    public var primaryBorderedButtonTextColor: Color = .errorDark
    public var secondaryButtonTextColor: Color = .white
    public var secondaryBorderedButtonTextColor: Color = .errorDark
    
    // MARK: - Button disabled Text colors
    public var defaultButtonDisabledTextColor: Color = .grey700
    public var borderedButtonDisabledTextColor: Color = .grey700

    // MARK: - Disabled button border color
    public var disabledButtonBorderColor: Color = .grey200
    
    // MARK: - Spinner
    public var spinnerPrimaryColor: Color = .white
    public var spinnerSecondaryColor: Color = .errorDark

    // MARK: - Progress
    public var progressBarBkgColor: Color = .white
    public var progressBarColor: Color = .errorGraphic

    // MARK: - Generic texts
    public var titleColor: Color = .errorDark
    public var subtitleColor: Color = .errorDark

}
