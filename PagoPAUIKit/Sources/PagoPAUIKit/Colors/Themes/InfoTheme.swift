//
//  InfoTheme.swift
//  
//
//  Created by Stefania Castiglioni on 23/11/23.
//

import SwiftUI

public struct InfoTheme: PagoPATheme {
    
    // MARK: - Toast color
    public var toastBackgroundColor: Color = .infoLight
    public var toastTextBorderBkgColor: Color = .infoDark
        
    // MARK: - Background color
    public var backgroundColor: Color = .infoLight
    
    // MARK: - Default icon (ex: for thankyou page)
    public var defaultIcon: Image.PAIcon? = .pendingDark

    // MARK: - Default buttons background color
    public var primaryButtonBkgColor: Color = .infoDark
    public var primaryBorderedButtonBkgColor: Color = .clear
    public var secondaryButtonBkgColor: Color = .infoGraphic
    public var secondaryBorderedButtonBkgColor: Color = .clear
    
    // MARK: - Default buttons disabled background color
    public var deafultButtonDisabledBkgColor: Color = .grey200
    public var borderedDisabledButtonBkgColor: Color = .clear

    // MARK: - Buttons text colors
    public var primaryButtonTextColor: Color = .white
    public var primaryBorderedButtonTextColor: Color = .infoDark
    public var secondaryButtonTextColor: Color = .white
    public var secondaryBorderedButtonTextColor: Color = .infoDark
    
    // MARK: - Button disabled Text colors
    public var defaultButtonDisabledTextColor: Color = .grey700
    public var borderedButtonDisabledTextColor: Color = .grey700

    // MARK: - Disabled button border color
    public var disabledButtonBorderColor: Color = .grey200
    
    // MARK: - Spinner
    public var spinnerPrimaryColor: Color = .white
    public var spinnerSecondaryColor: Color = .infoDark

    // MARK: - Progress
    public var progressBarBkgColor: Color = .white
    public var progressBarColor: Color = .infoGraphic

    // MARK: - Generic texts
    public var titleColor: Color = .infoDark
    public var subtitleColor: Color = .infoDark

}
