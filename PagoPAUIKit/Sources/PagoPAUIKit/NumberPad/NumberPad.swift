//
//  NumberPad.swift
//
//
//  Created by Stefania Castiglioni on 18/01/24.
//

import SwiftUI

public struct NumberPad: View {
    
    @Binding var string: String
    
    var type: PadType = .numeric
    var pinLength: Int
    
    public init(_ type: PadType, string: Binding<String>, pinLength: Int = 6) {
        self.type = type
        _string = string
        self.pinLength = pinLength
    }
    
    public enum PadType {
        case numeric
        case pin
    }
    
    public var body: some View {
        VStack(spacing: Constants.smallSpacing) {
            NumberPadRow(["1", "2", "3"])
            NumberPadRow(["4", "5", "6"])
            NumberPadRow(["7", "8", "9"])
            
            switch type {
            case .numeric:
                numericFooter
            case .pin:
                pinFooter
            }
        }
        .environment(\.keyPadButtonAction, self.keyPressed(_:))
        .frame(maxWidth: .infinity)
        .padding(.horizontal, Constants.mediumSpacing)
    }
    
    @ViewBuilder
    private var numericFooter: some View {
        HStack {
            KeyPadButton("00")
            KeyPadButton("0")
            KeyPadButton("cancel", icon: .backspace)
        }
        .frame(height: 56)
    }
    
    @ViewBuilder
    private var pinFooter: some View {
        HStack {
            Circle()
                .fill(.clear)
                .frame(width: 56, height: 56.0)
                .padding()
            
            KeyPadButton("0")
            KeyPadButton("cancel", icon: .backspace)
        }
        .frame(height: 56)
    }
    
}

extension NumberPad {
    
    private func keyPressed(_ key: String) {
        switch type {
        case .numeric:
            switch key {
            case "0" where string == "0,00" : break
            case "00" where string == "0,00" : break
            default:
                addDigitToAmount(key: key)
            }
        case .pin:
            if key == "cancel" {
                guard !string.isEmpty else {
                    break
                }
                string.removeLast()
                return
            }
            guard string.count < pinLength else {
                break
            }
            string += key
        }
    }
    
    private func addDigitToAmount(key: String) {
        if key == "cancel" {
            guard string != "0,00" else { return }
            string.removeLast()
        } else {
            string += key
        }
        var stringWithoutSeparator = string.replacingOccurrences(of: ",", with: "")
        while stringWithoutSeparator.hasPrefix("0") {
            stringWithoutSeparator.removeFirst()
        }
        guard !stringWithoutSeparator.isEmpty else {
            string = 0.formattedAmountNoCurrency
            return
        }
        guard let newAmount = Int(stringWithoutSeparator) else { return }
        string = newAmount.formattedAmountNoCurrency
    }
    
}

struct NumberPad_Previews: PreviewProvider {

    struct ContainerView: View {
        @State var amount: String = "0,00"

        var body: some View {
            VStack {
                Text("\(amount) €")
                    .font(.PAFont.h1Hero)
                Spacer()
                NumberPad(.numeric, string: $amount)
            }
            .padding(100)
        }
    }

    static var previews: some View {
        ContainerView()
    }

}

struct NumberPadPin_Previews: PreviewProvider {
    
    struct ContainerView: View {
        @State var pin: String = ""
        
        var body: some View {
            VStack {
                Text(pin)
                    .font(.PAFont.h1Hero)
                    .frame(maxWidth: .infinity)
                Spacer()
                NumberPad(.pin, string: $pin)
            }
            .padding(100)
        }
    }
    
    static var previews: some View {
        ContainerView()
    }
    
}
