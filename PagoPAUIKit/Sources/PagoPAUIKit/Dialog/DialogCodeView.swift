//
//  DialogCodeView.swift
//  
//
//  Created by Pier Domenico Bonamassa on 20/12/23.
//

import SwiftUI

struct DialogCodeView: View {
    
    var dialogModel: ResultModel
    var onClose: (() -> Void)
    var codeValue: String
    private let pastBoard = UIPasteboard.general
    
    public init(dialogModel: ResultModel, onClose: @escaping () -> Void, codeValue: String) {
        self.dialogModel = dialogModel
        self.onClose = onClose
        self.codeValue = codeValue
    }
        
    public var body: some View {
        ZStack {
            Color.overlay75
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                
                HStack {
                    Spacer()
                    Button() {
                        withAnimation {
                            onClose()
                        }
                    }label: {
                        Image(systemName: "xmark")
                            .foregroundColor(dialogModel.theme.titleColor)
                    }
                    .padding()
                    .foregroundColor(.paPrimary)
                    .cornerRadius(Constants.radius1)
                }
                .frame(minHeight: Constants.mediumSpacing)
                .padding(Constants.xsmallSpacing/2)
                
                ResultView(
                    result:
                        ResultModel(
                            title: dialogModel.title,
                            subtitle: dialogModel.subtitle,
                            icon: dialogModel.icon,
                            themeType: dialogModel.themeType,
                            buttons: dialogModel.buttons,
                            showLoading:dialogModel.showLoading)
                    
                )
                .padding(.bottom, Constants.mediumSpacing)
                
                HStack {
                    VStack{
                        Text(codeValue)
                            .onTapGesture(count: 1) {
                                pastBoard.string = codeValue
                            }
                            .font(.PAFont.h1Hero)
                            .kerning(6)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.paBlack)
                    }
                    .padding(Constants.largeSpacing)
                    .background(Color.grey50)
                    .cornerRadius(9.0)
                }.padding(.bottom, Constants.largeSpacing)
            }
            .background(dialogModel.theme.backgroundColor)
            .cornerRadius(16)
            .padding(Constants.mediumSpacing)
            
        }
        
    }
}

struct DialogCodeModifier: ViewModifier {
    var dialogModel: ResultModel
    var onClose: () -> Void
    @Binding var isPresenting: Bool
    var codeValue: String
    
    func body(content: Content) -> some View {
        content
            .overlay {
            if isPresenting {
                DialogCodeView(dialogModel: dialogModel, onClose: onClose, codeValue: codeValue)
            }
        }
    }
}

extension View {
    public func dialogCode(dialogModel:ResultModel, onClose: @escaping () -> Void, isPresenting: Binding<Bool>, codeValue: String) -> some View {
        modifier(DialogCodeModifier(dialogModel: dialogModel, onClose: onClose, isPresenting: isPresenting, codeValue: codeValue))
    }
}

public struct CodeDialogDemo: View {
    public init() {}
    public var body: some View {
        DialogCodeView(dialogModel:
                        ResultModel(
                            title: "Problemi con il QR?",
                            subtitle: "Entra sull’app IO, vai nella sezione Inquadra e digita il codice:",
                            themeType: ThemeType.light,
                            buttons:[]
                        ),
                       onClose: {
            print("test close")
        },
                       codeValue: "A7U8GHI3"
        )
    }
}

#Preview {
   CodeDialogDemo()
}
