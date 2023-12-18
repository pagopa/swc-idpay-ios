//
//  Constants.swift
//  
//
//  Created by Stefania Castiglioni on 04/12/23.
//

import Foundation
import UIKit

public struct Constants {
    
    public static let scaleFactor: CGFloat = UIDevice.isIpad ? 1.5 : 1.0
    
    // MARK: - Rounding values
    public static let radius1: CGFloat = 8
    
    // MARK: - Spacings
    public static let xsmallSpacing : CGFloat = Spacings.xsmall.rawValue * scaleFactor
    public static let smallSpacing  : CGFloat = Spacings.small.rawValue * scaleFactor
    public static let mediumSpacing : CGFloat = Spacings.medium.rawValue * scaleFactor
    public static let largeSpacing  : CGFloat = Spacings.large.rawValue * scaleFactor
    public static let xlargeSpacing : CGFloat = Spacings.xlarge.rawValue * scaleFactor
    public static let xxlargeSpacing: CGFloat = Spacings.xxlarge.rawValue * scaleFactor
    
    // MARK: - Sizes
    public static let buttonIconSize     : CGFloat = Sizes.buttonIcon.rawValue * scaleFactor
    public static let listItemIconSize   : CGFloat = Sizes.listItemIcon.rawValue * scaleFactor
    public static let topIconSize        : CGFloat = Sizes.topIcon.rawValue * scaleFactor
    public static let loaderSize         : CGFloat = Sizes.loader.rawValue * scaleFactor
}

extension UIDevice {
    static var isIpad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
}
