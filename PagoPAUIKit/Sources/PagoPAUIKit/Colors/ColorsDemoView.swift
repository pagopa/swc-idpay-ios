//
//  ColorsDemoView.swift
//  
//
//  Created by Stefania Castiglioni on 01/12/23.
//

import SwiftUI

struct ColorDemo {
    var name: String
    var color: Color
}

struct ColorDemoRow: View {
    
    var title: String
    var color: Color
    
    var body: some View {
        VStack {
            HStack(spacing: 2) {
                Text(title)
                    .foregroundStyle(Color.paBlack)
                Spacer()
                Rectangle()
                    .fill(color)
                    .frame(width: 180)
            }
        }
        .padding(.horizontal, Constants.smallSpacing)

    }
}

public struct ColorsDemoView: View {
    
    var allColors: [ColorDemo] = [
        ColorDemo(name: "Grey50", color: .grey50),
        ColorDemo(name: "Grey100", color: .grey100),
        ColorDemo(name: "Grey200", color: .grey200),
        ColorDemo(name: "Grey450", color: .grey450),
        ColorDemo(name: "Grey650", color: .grey650),
        ColorDemo(name: "Grey700", color: .grey700),
        ColorDemo(name: "Grey850", color: .grey850),
        ColorDemo(name: "PA Primary", color: .paPrimary),
        ColorDemo(name: "PA Black", color: .paBlack),
        ColorDemo(name: "PrimaryDark", color: .paPrimaryDark),
        ColorDemo(name: "PrimaryUltraDark", color: .paPrimaryUltraDark),
        ColorDemo(name: "Turquoise", color: .turquoise),
        ColorDemo(name: "TurquoiseDark", color: .turquoiseDark),
        ColorDemo(name: "TurquoiseLight", color: .turquoiseLight),
        ColorDemo(name: "Blue Border", color: .blueBorder),
        ColorDemo(name: "Blu Italia 50", color: .bluItalia50),
        ColorDemo(name: "Turquoise1", color: .turquoise1),
        ColorDemo(name: "Turquoise0.5", color: .turquoise05),
        ColorDemo(name: "PaleCornflowerBlue", color: .paleCornflowerBlue),
        ColorDemo(name: "BluItalia0.5", color: .bluItalia05),
        ColorDemo(name: "Overlay75", color: .overlay75),
        ColorDemo(name: "Overlay20", color: .overlay20),
        ColorDemo(name: "Overlay10", color: .overlay10),
        ColorDemo(name: "BlueIO500", color: .blueIO500),
        ColorDemo(name: "BlueIOLight", color: .blueIOLight),
        ColorDemo(name: "BlueIODark", color: .blueIODark),
        ColorDemo(name: "BlueIO", color: .blueIO),
        ColorDemo(name: "WarningLight", color: .warningLight),
        ColorDemo(name: "WarningGraphic", color: .warningGraphic),
        ColorDemo(name: "WarningDark", color: .warningDark),
        ColorDemo(name: "Warning", color: .warning),
        ColorDemo(name: "SuccessLight", color: .successLight),
        ColorDemo(name: "SuccessGraphic", color: .successGraphic),
        ColorDemo(name: "SuccessDark", color: .successDark),
        ColorDemo(name: "Success", color: .success),
        ColorDemo(name: "InfoLight", color: .infoLight),
        ColorDemo(name: "InfoGraphic", color: .infoGraphic),
        ColorDemo(name: "InfoDark", color: .infoDark),
        ColorDemo(name: "Info", color: .info),
        ColorDemo(name: "Error", color: .error),
        ColorDemo(name: "ErrorDark", color: .errorDark),
        ColorDemo(name: "ErrorLight", color: .errorLight),
        ColorDemo(name: "ErrorGraphic", color: .errorGraphic)
    ]
    
    public init() {}
    
    public var body: some View {
        ScrollView {
            VStack {
                ForEach(allColors, id:\.name) { color in
                    ColorDemoRow(title: color.name, color: color.color)
                        .frame(height: 40)

                }
            }
            
        }
    }
}

#Preview {
    ColorsDemoView()
}
