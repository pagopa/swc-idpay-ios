//
//  WarningTheme.swift
//  
//
//  Created by Stefania Castiglioni on 23/11/23.
//

import SwiftUI

public struct WarningTheme: PagoPATheme {
        
    // MARK: - Background color
    public var backgroundColor: Color = .warningLight
    
    // MARK: - Toast color
    public var toastBackgroundColor: Color = .warningLight
    public var toastTextBorderBkgColor: Color = .warningDark

    // MARK: - Default buttons background color
    public var primaryButtonBkgColor: Color = .warningDark
    public var primaryBorderedButtonBkgColor: Color = .clear
    public var secondaryButtonBkgColor: Color = .warningGraphic
    public var secondaryBorderedButtonBkgColor: Color = .clear
    
    // MARK: - Default buttons disabled background color
    public var deafultButtonDisabledBkgColor: Color = .grey200
    public var borderedDisabledButtonBkgColor: Color = .clear

    // MARK: - Buttons text colors
    public var primaryButtonTextColor: Color = .white
    public var primaryBorderedButtonTextColor: Color = .warningDark
    public var secondaryButtonTextColor: Color = .white
    public var secondaryBorderedButtonTextColor: Color = .warningDark
    
    // MARK: - Button disabled Text colors
    public var defaultButtonDisabledTextColor: Color = .grey700
    public var borderedButtonDisabledTextColor: Color = .grey700

    // MARK: - Disabled button border color
    public var disabledButtonBorderColor: Color = .grey200
    
    // MARK: - Spinner
    public var spinnerPrimaryColor: Color = .white
    public var spinnerSecondaryColor: Color = .warningDark
    
    // MARK: - Progress
    public var progressBarBkgColor: Color = .white
    public var progressBarColor: Color = .warningGraphic


}
