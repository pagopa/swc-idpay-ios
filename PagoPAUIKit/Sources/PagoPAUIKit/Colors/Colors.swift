//
//  Colors.swift
//  
//
//  Created by Stefania Castiglioni on 21/11/23.
//

import SwiftUI

extension Color {
    
    init(_ name: String) {
        self.init(name, bundle: .module)
    }
    
    // MARK: - Neutrals
    public static var paBlack: Color {
        Color("Black")
    }
    
    public static var grey50: Color {
        Color("Grey50")
    }
    
    public static var grey100: Color {
        Color("Grey100")
    }
    
    public static var grey200: Color {
        Color("Grey200")
    }
    
    public static var grey450: Color {
        Color("Grey450")
    }
    
    public static var grey650: Color {
        Color("Grey650")
    }
    
    public static var grey700: Color {
        Color("Grey700")
    }
    
    public static var grey850: Color {
        Color("Grey850")
    }
    
    // MARK: - PrimaryPagoPA
    public static var paPrimary: Color {
        Color("Primary")
    }
    
    public static var paPrimaryDark: Color {
        Color("PrimaryDark")
    }
    
    public static var paPrimaryUltraDark: Color {
        Color("PrimaryUltraDark")
    }
    
    // MARK: - Turquoise
    public static var turquoise: Color {
        Color("Turquoise")
    }

    public static var turquoiseDark: Color {
        Color("TurquoiseDark")
    }

    public static var turquoiseLight: Color {
        Color("TurquoiseLight")
    }

    // MARK: - Status
    public static var error: Color {
        Color("Error")
    }

    public static var errorDark: Color {
        Color("ErrorDark")
    }

    public static var errorGraphic: Color {
        Color("ErrorGraphic")
    }
    
    public static var errorLight: Color {
        Color("ErrorLight")
    }

    public static var info: Color {
        Color("Info")
    }

    public static var infoDark: Color {
        Color("InfoDark")
    }
    
    public static var infoGraphic: Color {
        Color("InfoGraphic")
    }
    
    public static var infoLight: Color {
        Color("InfoLight")
    }
    
    public static var success: Color {
        Color("Success")
    }
    
    public static var successDark: Color {
        Color("SuccessDark")
    }
    
    public static var successGraphic: Color {
        Color("SuccessGraphic")
    }
    
    public static var successLight: Color {
        Color("SuccessLight")
    }
    
    public static var warning: Color {
        Color("Warning")
    }
    
    public static var warningDark: Color {
        Color("WarningDark")
    }
    
    public static var warningGraphic: Color {
        Color("WarningGraphic")
    }
    
    public static var warningLight: Color {
        Color("WarningLight")
    }
    
    // MARK: - PrimaryIO
    public static var blueIO: Color {
        Color("BlueIO")
    }
    
    public static var blueIODark: Color {
        Color("BlueIODark")
    }
    
    public static var blueIOLight: Color {
        Color("BlueIOLight")
    }
    
    public static var blueIO500: Color {
        Color("BlueIO500")
    }
    
    // MARK: - Overlay
    public static var overlay10: Color {
        Color("Overlay10")
    }
    
    public static var overlay20: Color {
        Color("Overlay20")
    }
    
    public static var overlay75: Color {
        Color("Overlay75")
    }
    
    // MARK: - Extras
    public static var bluItalia05: Color {
        Color("BluItalia0.5")
    }
    
    public static var paleCornflowerBlue: Color {
        Color("PaleCornflowerBlue")
    }
    
    public static var turquoise05: Color {
        Color("Turquoise0.5")
    }
    
    public static var turquoise1: Color {
        Color("Turquoise1")
    }
    
    public static var bluItalia50: Color {
        Color("BluItalia50")
    }
    
    public static var blueBorder: Color {
        Color("BlueBorder")
    }
}
