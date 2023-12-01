//
//  File.swift
//  
//
//  Created by Stefania Castiglioni on 23/11/23.
//

import SwiftUI

public struct LightTheme: PagoPATheme {
        
    // MARK: - Background color
    public var backgroundColor: Color = .grey100

    // MARK: - Default buttons background color
    public var primaryButtonBkgColor: Color = .paPrimary
    public var primaryBorderedButtonBkgColor: Color = .white
    public var secondaryButtonBkgColor: Color = .paPrimaryDark
    public var secondaryBorderedButtonBkgColor: Color = .bluItalia05
    
    // MARK: - Default buttons disabled background color
    public var deafultButtonDisabledBkgColor: Color = .grey200
    public var borderedDisabledButtonBkgColor: Color = .white

    // MARK: - Buttons text colors
    public var primaryButtonTextColor: Color = .white
    public var primaryBorderedButtonTextColor: Color = .paPrimary
    public var secondaryButtonTextColor: Color = .white
    public var secondaryBorderedButtonTextColor: Color = .paPrimaryDark
    
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

    
}
