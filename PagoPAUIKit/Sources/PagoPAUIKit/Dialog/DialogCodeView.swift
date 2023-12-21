//
//  DialogCodeView.swift
//
//
//  Created by Pier Domenico Bonamassa on 20/12/23.
//

import SwiftUI

struct DialogCodeView: View {
    
    var title: String
    var subtitle: String
    var codeValue: String

    @Binding var isPresenting: Bool

    var onClose: (() -> Void)
        
    public init(title: String, subtitle: String, codeValue: String, isPresenting: Binding<Bool>, onClose: @escaping () -> Void) {
        self.title = title
        self.subtitle = subtitle
        _isPresenting = isPresenting
        self.onClose = onClose
        self.codeValue = codeValue
    }
    
    public var body: some View {
        ZStack {
            if isPresenting {
                Color.overlay75
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    HStack {
                        Spacer()
                        Button() {
                            isPresenting = false
                            onClose()
                        } label: {
                            Image(icon: .close)
                                .foregroundColor(.paPrimary)
                        }
                        .padding()
                        .foregroundColor(.paPrimary)
                        .cornerRadius(Constants.radius1)
                    }
                    .frame(minHeight: Constants.mediumSpacing)
                    .padding(Constants.xsmallSpacing/2)
                    
                    VStack(spacing: Constants.xsmallSpacing) {
                        Text(title)
                            .multilineTextAlignment(.center)
                            .font(.PAFont.h3)
                            .foregroundColor(.blueIODark)
                        
                        Text(subtitle)
                            .multilineTextAlignment(.center)
                            .font(.PAFont.body)
                            .foregroundColor(.blueIODark)
                    }
                    .padding(.horizontal, Constants.smallSpacing)
                    .padding(.bottom, Constants.mediumSpacing)
                    
                    Text(codeValue)
                        .textSelection(.enabled)
                        .font(.PAFont.h1Hero)
                        .kerning(6)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.paBlack)
                        .padding(Constants.mediumSpacing)
                        .background(Color.grey50)
                        .cornerRadius(Constants.radius1)
                        .padding(.bottom, Constants.largeSpacing)
                }
                .background(.white)
                .cornerRadius(Constants.radius2)
                .padding(Constants.mediumSpacing)
            }
        }
        .animation(.spring(duration: 0.1), value: isPresenting)
    }
}

struct DialogCodeModifier: ViewModifier {
    var title: String
    var subtitle: String
    var codeValue: String
    
    @Binding var isPresenting: Bool
    
    var onClose: () -> Void
    
    func body(content: Content) -> some View {
        ZStack {
            content
                    
            DialogCodeView(title: title, subtitle: subtitle, codeValue: codeValue, isPresenting: $isPresenting, onClose: onClose)
        }
    }
}

extension View {
    public func dialogCode(title: String, subtitle: String, codeValue: String,  isPresenting: Binding<Bool>, onClose: @escaping () -> Void) -> some View {
        modifier(DialogCodeModifier(title: title, subtitle: subtitle, codeValue: codeValue, isPresenting: isPresenting, onClose: onClose))
    }
}

public struct CodeDialogDemo: View {
    
    @State var isPresenting: Bool = true

    public init() {}
    public var body: some View {
        DialogCodeView(
            title: "Problemi con il QR?",
            subtitle: "Entra sull’app IO, vai nella sezione Inquadra e digita il codice:",
            codeValue: "A7U8GHI3",
            isPresenting: $isPresenting,
            onClose: {
                print("test close")
            }
        )
    }
}

#Preview {
    CodeDialogDemo()
}
