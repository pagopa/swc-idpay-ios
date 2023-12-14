//
//  InputDemoView.swift
//
//
//  Created by Stefania Castiglioni on 14/12/23.
//

import SwiftUI

public struct InputDemoView: View {
    
    @FocusState var focusedField: Int?
    @State var input1: String = ""
    @State var input2: String = ""
    @State var otp: String = ""
    @State var password: String = ""
    @State var email: String = ""
    
    public init() {}
    
    public var body: some View {
        Form {
            InputField(
                type: .text,
                text: $input1,
                placeholder: "Required input field",
                validationRule: .requiredText)
            .focused($focusedField, equals: 1)
            
            InputField(
                type: .text,
                text: $input2,
                placeholder: "Text input field with length defined",
                validationRule: .requiredLength(8, .text)
            )
            .focused($focusedField, equals: 2)

            InputField(
                type: .number,
                text: $otp,
                placeholder: "OTP Field",
                caption: "Field suggestion",
                validationRule: .otp
            )
            .focused($focusedField, equals: 3)

            InputField(
                type: .password,
                text: $password,
                placeholder: "Password",
                validationRule: .none
            )
            .focused($focusedField, equals: 4)

            InputField(
                type: .text,
                text: $email,
                placeholder: "Email",
                caption: "Field suggestion",
                validationRule: .email
            )
            .focused($focusedField, equals: 5)

            
            Button {
                validate()
            } label: {
                Text("OK")
            }
            .pagoPAButtonStyle(buttonType: .primary)
            .padding(.vertical, 24)
        }
        .formStyle(.columns)
        .padding(24)
    }
    
    private func validate() {
        focusedField = nil
    }
}

#Preview {
    InputDemoView()
}
