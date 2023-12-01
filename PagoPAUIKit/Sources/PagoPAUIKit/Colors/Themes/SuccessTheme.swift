//
//  SuccessTheme.swift
//  
//
//  Created by Stefania Castiglioni on 23/11/23.
//

import SwiftUI

public struct SuccessTheme: PagoPATheme {
        
    // MARK: - Background color
    public var backgroundColor: Color = .successLight

    // MARK: - Default buttons background color
    public var primaryButtonBkgColor: Color = .successDark
    public var primaryBorderedButtonBkgColor: Color = .clear
    public var secondaryButtonBkgColor: Color = .successGraphic
    public var secondaryBorderedButtonBkgColor: Color = .clear
    
    // MARK: - Default buttons disabled background color
    public var deafultButtonDisabledBkgColor: Color = .grey200
    public var borderedDisabledButtonBkgColor: Color = .clear

    // MARK: - Buttons text colors
    public var primaryButtonTextColor: Color = .white
    public var primaryBorderedButtonTextColor: Color = .successDark
    public var secondaryButtonTextColor: Color = .white
    public var secondaryBorderedButtonTextColor: Color = .successDark
    
    // MARK: - Button disabled Text colors
    public var defaultButtonDisabledTextColor: Color = .grey700
    public var borderedButtonDisabledTextColor: Color = .grey700

    // MARK: - Disabled button border color
    public var disabledButtonBorderColor: Color = .grey200
    
    // MARK: - Spinner
    public var spinnerPrimaryColor: Color = .white
    public var spinnerSecondaryColor: Color = .successDark
    
    // MARK: - Progress
    public var progressBarBkgColor: Color = .white
    public var progressBarColor: Color = .successGraphic

}
