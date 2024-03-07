//
//  InputField.swift
//  
//
//  Created by Stefania Castiglioni on 04/12/23.
//

import SwiftUI

/**
 Custom input field with floating label, border color and chars counting.
 
 - parameter type: type of the textfield (text, password or number).
 - parameter text: Binding to a string
 - parameter placeholder: text to show inside the textfield, when empty, 
                    used as floating label while writing or textfield filled
 - parameter maxLength: max length or required length of text in textfield
 - parameter autofocus: place the cursor inside the textfield on appear

 - # Notes: #
 Please provide a maxLength if you want to show counter label. 
 
 - # Example #
 ```
 struct InputDemoView: View {
 @State var username: String = ""
 @State var password: String = ""
 @State var otp: String = ""

 @FocusState var focusedField: Int?
 
 var body: some View {
     VStack {
         InputField(type: .text, text: $username, placeholder: "Username")
             .focused($focusedField, equals: 0)
         
         InputField(type: .password, text: $password, placeholder: "Password")
             .focused($focusedField, equals: 1)
         
         InputField(type: .number, text: $otp, placeholder: "OTP code", maxLength: 18)
             .focused($focusedField, equals: 2)
         
     }
     .padding(24)
 }

}

 ```
 
 */
public struct InputField: View {
    private var type: InputType
    @Binding var text: String
    private var placeholder: String
    private var captionHint: String?
    private var validationRule: RuleType?
    private var autofocus: Bool = false
    @Binding var errorText: String?
    
    @State private var status: InputStatus = .unknown
    @State private var caption: String?
    @State private var charsCount: Int = 0
    @State private var isEditing = false
    
    @Environment(\.isEnabled) private var isEnabled
    @FocusState private var focused: Bool

    enum InputStatus {
        case unknown
        case success
        case error
        
        var icon: Image.PAIcon? {
            switch self {
            case .success:
                return .checkmark
            case .error:
                return .warning
            default:
                return nil
            }
        }
        
        var captionColor: Color {
            switch self {
            case .error:
                return .errorGraphic
            default:
                return .grey700
            }
        }
    }
    
    public init(type: InputType,
                text: Binding<String>,
                placeholder: String,
                caption: String? = nil,
                errorText: Binding<String?> = .constant(nil),
                validationRule: RuleType? = nil,
                autofocus: Bool = false) {
        
        self.type = type
        _text = text
        self.placeholder  = placeholder
        self.captionHint  = caption
        self.caption      = captionHint
        _errorText        = errorText
        self.validationRule = validationRule
        self.autofocus    = autofocus
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            Group {
                if type == .password {
                    SecureField("", text: $text)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                } else {
                    TextField("", text: $text, onEditingChanged: {
                        self.isEditing = $0
                    })
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .keyboardType(type.keyboardType)
                }
            }
            .textFieldStyle(
                BorderedTextFieldStyle(
                    isEditing: Binding<Bool>(
                        get: { focused },
                        set: { self.isEditing = $0 }
                    ),
                    text: $text,
                    placeholder: placeholder,
                    icon: type.icon,
                    status: $status
                )
            )
            .focused($focused)
            .disabled(!isEnabled)
            .onAppear {
                if autofocus {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        self.focused = true
                    }
                }
            }
            .onChange(of: errorText) { newValue in
                switch newValue {
                case nil:
                    status = .unknown
                    caption = nil
                default:
                    status = .error
                    caption = newValue
                }
            }
            .onChange(of: text) { newValue in
                guard !newValue.isEmpty else {
                    charsCount = 0
                    return
                }
                
                // Update charsCount if needed
                if validationRule?.maxLength != nil {
                    // Avoid inputs after maxLenght
                    if let maxLengthWithSpaces {
                        text = String(text.prefix(maxLengthWithSpaces))
                    }

                    updateCount()
                }

                // Format textfield if needed
                formatText(newValue)

                // Update textfield status
                updateStatus()
            }
            
            // Caption and chars count
            captionLabel
        }
        .padding(.top, 12)
        .onChange(of: focused) { newValue in
            guard newValue == false else {
                status = .unknown
                caption = captionHint
                return
            }
            executeValidation()
        }

    }
    
    private var foregroundColor: Color {
        guard isEnabled else { return Color.grey200.opacity(0.5) }
        if focused == true && !text.isEmpty {
            return Color.paBlack
        }
        return Color.grey200
    }
    
    @ViewBuilder
    private var captionLabel: some View {
        HStack {
            if let caption = caption {
                Text(caption)
            }
            Spacer()
            // If maxLength provided show label for characters count
            if let maxLength = validationRule?.maxLength {
                Text("\(charsCount) / \(maxLength)")
                    .multilineTextAlignment(.trailing)
            }
        }
        .font(.PAFont.body)
        .foregroundColor(status.captionColor)
    }
        
    // MARK: - Text utilities and formatting
    
    private var maxLengthWithSpaces: Int? {
        guard let maxLength = validationRule?.maxLength else { return nil }
        return maxLength + text.filter {$0 == " "}.count
    }

    private func formatText(_ newText: String) {
        
        guard let chunkStep = type.chunkStep else { return }
        // Add whitespaces at chunkStep
        if text.trimmingCharacters(in: .whitespaces).count % (chunkStep + 1) == 0 {
            text = newText
            text.insert(" ", at: newText.index(newText.endIndex, offsetBy: -1))
        }

        // Remove trailing space on erase
        if newText.last == " ", newText.count > 1 {
            text = String(newText.prefix(newText.count-1))
        }
    }
    
    /// Update charsCount in caption
    private func updateCount() {
        if let _ = type.chunkStep {
            // Calculate chars count excluding whitespaces
            charsCount = text.replacingOccurrences(of: " ", with: "").count
        } else {
            charsCount = text.count
        }
    }
    
    /// Update textfield status
    private func updateStatus() {
        guard let maxLength = validationRule?.maxLength else { return }
        if maxLength == charsCount {
            status = .success
        } else {
            status = .unknown
        }
    }
    
    /// Validate textfield
    private func executeValidation() {
        guard let validationRule else { return }
        guard validateField(rule: validationRule) else {
            status = .error
            caption = validationRule.errorDescription
            return
        }
        
        status = .success
        caption = captionHint
    }
}

private struct InputListDemo: View {
    @State var username: String = ""
    @State var password: String = ""
    @State var otp: String = ""

    @State var passwordError: String?
    @State var showLoginSuccess: Bool = false
    @FocusState var focusedField: Int?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                InputField(type: .text, text: $username, placeholder: "Username")
                    .focused($focusedField, equals: 0)
                
                InputField(
                    type: .password,
                    text: $password,
                    placeholder: "Password",
                    caption: "Fill with your password",
                    errorText: $passwordError
                )
                .focused($focusedField, equals: 1)
                
                InputField(type: .number, text: $otp, placeholder: "OTP code", validationRule: .otp)
                    .focused($focusedField, equals: 2)
                
                Button {
                    focusedField = nil
                    validateForm()
                } label: {
                    Text("OK")
                }
                .pagoPAButtonStyle(buttonType: .primary)
                .disabled(username.isEmpty || password.isEmpty)
                .alert("Login done", isPresented: $showLoginSuccess) {
                    Button("OK", role: .cancel) {
                        showLoginSuccess.toggle()
                    }
                }
                .padding(.vertical, 40)
            }
            .padding(24)

        }
        .onTapGesture {
            focusedField = nil
        }
    }
    
    func validateForm() {
        guard password == "access" else {
            passwordError = "Password is not valid"
            return
        }
        passwordError = nil
        showLoginSuccess = true
    }

}

#Preview {
    InputListDemo()
}
