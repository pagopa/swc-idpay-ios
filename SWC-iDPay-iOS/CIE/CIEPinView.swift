//
//  CIEPinView.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 22/01/24.
//

import SwiftUI
import PagoPAUIKit

struct CIEPinView: View {
    @State var pinString: String = ""
    @State var isLoading: Bool = false

    var length: Int = 6
    
    var body: some View {
        
        VStack {
            Text("Inserisci il codice ID Pay")
                .font(.PAFont.h6)
                .padding(.bottom, Constants.largeSpacing)

            HStack(spacing: Constants.smallSpacing) {
                ForEach(0..<length, id:\.self) { n in
                    PinDot(filled: Binding<Bool> (
                        get: { pinString.count > n },
                        set: { _ in }
                    ))
                }
            }
            
            Spacer()
            pinView
        }
        .padding(Constants.mediumSpacing)

    }
    
    @ViewBuilder
    private var pinView: some View {
        Spacer()
        NumberPad(.pin, string: $pinString, pinLength: length)
        Spacer()
        CustomLoadingButton(
            buttonType: .primary,
            isLoading: $isLoading) {
                #if DEBUG
                print("PIN: \(pinString)")
                #endif
            } label: {
                Text("Conferma")
            }
            .disabled(pinString.count < length)
    }
}

private struct PinDot: View {
    
    @Binding var filled: Bool
    
    var body: some View {
        Circle()
            .stroke(filled ? Color.clear : Color.paPrimary, lineWidth: 2.0 * Constants.scaleFactor)
            .background(dotBackground)
            .frame(width: Constants.pinDotSize)
    }
    
    @ViewBuilder
    var dotBackground: some View {
        if filled == true {
            Circle().fill(Color.paPrimary)
        } else {
            EmptyView()
        }
    }
}

#Preview {
    HStack {
        PinDot(filled: .constant(true))
        PinDot(filled: .constant(true))
        PinDot(filled: .constant(false))
        PinDot(filled: .constant(false))
        PinDot(filled: .constant(false))
    }
}

#Preview {
    CIEPinView()
}
