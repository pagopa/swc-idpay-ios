//
//  PagoPATheme.swift
//  
//
//  Created by Stefania Castiglioni on 23/11/23.
//

import SwiftUI

public protocol PagoPATheme {
    var backgroundColor: Color { get }
    
    var primaryButtonBkgColor: Color { get }
    var primaryBorderedButtonBkgColor: Color { get }
    var secondaryButtonBkgColor: Color { get }
    var secondaryBorderedButtonBkgColor: Color { get }
    
    var deafultButtonDisabledBkgColor: Color { get }
    var borderedDisabledButtonBkgColor: Color { get }
    
    var primaryButtonTextColor: Color { get }
    var primaryBorderedButtonTextColor: Color { get }
    var secondaryButtonTextColor: Color { get }
    var secondaryBorderedButtonTextColor: Color { get }

    var defaultButtonDisabledTextColor: Color { get }
    var borderedButtonDisabledTextColor: Color { get }
    
    var disabledButtonBorderColor: Color { get }
    
    var spinnerPrimaryColor: Color { get }
    var spinnerSecondaryColor: Color { get }
    
    var progressBarBkgColor: Color { get }
    var progressBarColor: Color { get }
}
