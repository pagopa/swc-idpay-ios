//
//  Fonts.swift
//  
//
//  Created by Stefania Castiglioni on 22/11/23.
//

import Foundation
import SwiftUI

fileprivate enum FontError: LocalizedError {
   case failedToRegisterFont(String)
    
    var localizedDescription: String {
        switch self {
        case .failedToRegisterFont(let fontName):
            return "Couldn't create font from filename \(fontName)"
        }
    }
}

extension Font {
    
    private enum PAFontFile: String, CaseIterable {
        // Readex
        case readex_pro                       = "readex_pro"
        case readex_pro_extra_light           = "readex_pro_extra_light"
        case readex_pro_light                 = "readex_pro_light"
        case readex_pro_medium                = "readex_pro_medium"
        case readex_pro_semibold              = "readex_pro_semi_bold"

        // Titillium
        case titillium_web_black              = "titillium_web_black"
        case titillium_web_bold_italic        = "titillium_web_bold_italic"
        case titillium_web_bold               = "titillium_web_bold"
        case titillium_web_extra_light_italic = "titillium_web_extra_light_italic"
        case titillium_web_extra_light        = "titillium_web_extra_light"
        case titillium_web_italic             = "titillium_web_italic"
        case titillium_web_light_italic       = "titillium_web_light_italic"
        case titillium_web_light              = "titillium_web_light"
        case titillium_web_regular            = "titillium_web_regular"
        case titillium_web_semi_bold_italic   = "titillium_web_semi_bold_italic"
        case titillium_web_semi_bold          = "titillium_web_semi_bold"
        
        // Roboto
        case roboto_black_italic              = "roboto_black_italic"
        case roboto_black                     = "roboto_black"
        case roboto_bold_italic               = "roboto_bold_italic"
        case roboto_bold                      = "roboto_bold"
        case roboto_italic                    = "roboto_italic"
        case roboto_light_italic              = "roboto_light_italic"
        case roboto_light                     = "roboto_light"
        case roboto_medium_italic             = "roboto_medium_italic"
        case roboto_medium                    = "roboto_medium"
        case roboto_mono                      = "roboto_mono"
        case roboto_regular                   = "roboto_regular"

    }

    private enum PAFontType: String {
        // Readex
        case readexPro              = "ReadexPro-Regular"
        case readexProBold          = "ReadexPro-Bold"
        case readexProExtraLight    = "ReadexPro-ExtraLight"
        case readexProLight         = "ReadexPro-Light"
        case readexProMedium        = "ReadexPro-Medium"
        case readexProSemiBold      = "ReadexPro-SemiBold"
        
        // Titillium
        case titilliumWebBlack              = "TitilliumWeb-Black"
        case titilliumWebBoldItalic         = "TitilliumWeb-BoldItalic"
        case titilliumWebBold               = "TitilliumWeb-Bold"
        case titilliumWebExtraLightItalic   = "TitilliumWeb-ExtraLightItalic"
        case titilliumWebExtraLight         = "TitilliumWeb-ExtraLight"
        case titilliumWebItalic             = "TitilliumWeb-Italic"
        case titilliumWebLightItalic        = "TitilliumWeb-LightItalic"
        case titilliumWebLight              = "TitilliumWeb-Light"
        case titilliumWebRegular            = "TitilliumWeb-Regular"
        case titilliumWebSemiBoldItalic     = "TitilliumWeb-SemiBoldItalic"
        case titilliumWebSemiBold           = "TitilliumWeb-SemiBold"
        
        // Roboto
        case robotoBlackItalic              = "Roboto-BlackItalic"
        case robotoBlack                    = "Roboto-Black"
        case robotoBoldItalic               = "Roboto-BoldItalic"
        case robotoBold                     = "Roboto-Bold"
        case robotoItalic                   = "Roboto-Italic"
        case robotoLightItalic              = "Roboto-LightItalic"
        case robotoLight                    = "Roboto-Light"
        case robotoMediumItalic             = "Roboto-MediumItalic"
        case robotoMedium                   = "Roboto-Medium"
        case robotoMono                     = "RobotoMono-Regular"
        case robotoRegular                  = "Roboto-Regular"

    }
    
    private enum FontSize: CGFloat {
        case largeTitle = 32
        case title = 28
        case title2 = 26
        case title3 = 22
        case headline = 20
        case callout = 14
        case body = 16
        case caption = 12
        case receiptTitle2 = 11
        
        var textStyle: Font.TextStyle {
            switch self {
            case .largeTitle:
                return .largeTitle
            case .title:
                return .title
            case .title2:
                return .title2
            case .title3:
                return .title3
            case .headline:
                return .headline
            case .callout:
                return .callout
            case .body:
                return .body
            case .caption:
                return .caption
            case .receiptTitle2:
                return .caption2
            }
        }
    }
    
    
    public struct PAFont {
     
        public static var h1Hero: Font {
            PAFont.relative(.readexPro, size: .largeTitle)
        }
        
        public static var h1: Font {
            PAFont.relative(.readexPro, size: .title)
        }
        
        public static var h2: Font {
            PAFont.relative(.readexPro, size: .title2)
        }
        
        public static var h3: Font {
            PAFont.relative(.readexPro, size: .title3)
        }
        
        public static var h4: Font {
            PAFont.relative(.readexPro, size: .headline)
        }
        
        public static var h5: Font {
            PAFont.relative(.titilliumWebSemiBold, size: .callout)
        }

        public static var h6: Font {
            PAFont.relative(.readexPro, size: .body)
        }
        
        public static var cta: Font {
            PAFont.relative(.readexPro, size: .body)
        }
        
        public static var caption: Font {
            PAFont.relative(.readexPro, size: .caption)
        }
        
        public static var navigazione: Font {
            PAFont.relative(.readexPro, size: .caption)
        }
        
        public static var body: Font {
            PAFont.relative(.titilliumWebRegular, size: .body)
        }
        
        public static var bodySB: Font {
            PAFont.relative(.titilliumWebSemiBold, size: .body)
        }
        
        public static var linkInline: Font {
            PAFont.relative(.titilliumWebSemiBold, size: .body)
        }
        
        public static var labelRegular: Font {
            PAFont.relative(.titilliumWebRegular, size: .body)
        }
        
        public static var labelSB: Font {
            PAFont.relative(.titilliumWebSemiBold, size: .body)
        }
        
        public static var labelRegularB: Font {
            PAFont.relative(.titilliumWebBold, size: .body)
        }
        
        public static var labelSmall: Font {
            PAFont.relative(.titilliumWebRegular, size: .callout)
        }
        
        public static var labelSmallSB: Font {
            PAFont.relative(.titilliumWebSemiBold, size: .callout)
        }
        
        public static var labelMini: Font {
            PAFont.relative(.titilliumWebRegular, size: .caption)
        }
        
        public static var labelMiniSB: Font {
            PAFont.relative(.titilliumWebSemiBold, size: .caption)
        }
        
        public static var receiptTitle: Font {
            PAFont.fixed(.titilliumWebBold, size: 12)
        }
        
        public static var receiptTitle2: Font {
            PAFont.fixed(.titilliumWebRegular, size: 11)
        }
        
        public static var receiptLabelB: Font {
            PAFont.fixed(.titilliumWebBold, size: 11)
        }
        
        public static var receiptAmountLabelB: Font {
            PAFont.fixed(.titilliumWebBold, size: 16)
        }
        
        public static var receiptMetadata: Font {
            PAFont.fixed(.robotoMono, size: 11)
        }
        
        /// Create font with a fixed size
        private static func fixed(_ fontType: PAFontType, size: CGFloat) -> Font {
           return Font.custom(fontType.rawValue, fixedSize: size)
        }

        private static func relative(_ fontType: PAFontType, size: FontSize) -> Font {
            return Font.custom(fontType.rawValue, size: size.rawValue * Constants.scaleFactor, relativeTo: size.textStyle)
        }

    }
    
    /**
     Register all PagoPA Fonts in main application.
     
     - Example:
            
            struct PagoPAUIKitDemoApp: App {
         
                init() {
                    Font.registerPagoPAFonts()
                }
         
                var body: some Scene {
                    WindowGroup {
                        ContentView(fontType: "H1", font: .PAFont.h1)
                    }
                }
            }
     - Important: must call in app init before start using custom fonts.

   */
    public static func registerPagoPAFonts() {
        PAFontFile.allCases.forEach { font in
            do {
                try registerFont(bundle: .module, fontName: font.rawValue, fontExtension: "ttf")
            } catch let error as FontError {
                print(error.localizedDescription)
                return
            } catch {
                print("Error registering font:\(error.localizedDescription)")
                return
            }
        }
    }
    
    /// Register a font to use it
    fileprivate static func registerFont(bundle: Bundle, fontName: String, fontExtension: String) throws {
        guard let fontURL = bundle.url(forResource: fontName, withExtension: fontExtension),
            let fontDataProvider = CGDataProvider(url: fontURL as CFURL),
            let font = CGFont(fontDataProvider),
            CTFontManagerRegisterGraphicsFont(font, nil) else {
            throw(FontError.failedToRegisterFont(fontName + "." + fontExtension))
        }
    }

}
