//
//  LoginView.swift
//
//
//  Created by Stefania Castiglioni on 05/12/23.
//

import SwiftUI

public struct LoginView: View {
    
    var title: String
    var topImage: Image?

    @State var username: String = ""
    @State var password: String = ""
    @State private var isLoading: Bool = false
    
    private var onLoggedIn: () -> Void = { }
    @FocusState private var focusedField: Field?
    
    private enum Field: Int, CaseIterable, Hashable {
        case username, password, loginButton
    }
    
    public init(title: String, topImage: Image? = nil, onLoggedIn: @escaping () -> Void) {
        self.title = title
        self.topImage  = topImage
        self.onLoggedIn = onLoggedIn
    }
    
    public var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                ZStack {
                    Color
                        .white
                        .onTapGesture {
                            focusedField = nil
                        }
                    
                    VStack {
                        topImage
                            .foregroundColor(.paPrimary)
                        
                        Text(title)
                            .font(.PAFont.h4)
                            .padding(Constants.largeSpacing)
                        loginForm
                        Spacer()
                    }
                }
            }
            .scrollIndicators(.hidden)
            .onChange(of: focusedField) { newValue in
                guard newValue != nil else { return }
                proxy.scrollTo(newValue)
            }
            .background(Color.white)
        }
    }
    
    private func login() async -> Bool {
        print("Call login in viewmodel with user:\(username), password: \(password)")
        isLoading = true
        try? await Task.sleep(nanoseconds: 1 * 4_000_000_000) // 4 second
        isLoading = false
        return password == "access"
    }
    
    @ViewBuilder
    private var loginForm: some View {
        Form {
            InputField(type: .text, text: $username, placeholder: "Username", autofocus: true)
                .focused($focusedField, equals: .username)
                .submitLabel(.next)
                .onSubmit {
                    focusedField = .password
                }
                .disabled(isLoading)
                .id(Field.username)
            
            InputField(type: .password, text: $password, placeholder: "Password", autofocus: false)
                .focused($focusedField, equals: .password)
                .submitLabel(.done)
                .disabled(isLoading)
                .onSubmit {
                    guard isFormValid else { return }
                    submitForm()
                }
                .id(Field.password)
            
            CustomLoadingButton(buttonType: .primary, isLoading: $isLoading) {
                submitForm()
            } label: {
                Text("Accedi")
            }
            .disabled(!isFormValid)
            .padding(.vertical, Constants.smallSpacing)
            .id(Field.loginButton)
        }
        .formStyle(.columns)
        .padding(.horizontal, Constants.smallSpacing)
        
    }
    
    private func submitForm() {
        focusedField = nil
        Task {
            if await login(){
                onLoggedIn()
            } else {
                print("Display error")
            }
        }
    }
    
    private var isFormValid: Bool {
        !(username.isEmpty || password.isEmpty)
    }
}

#Preview {
    LoginView(title: "Ambiente di test", topImage: Image(icon: .idPayLogo) , onLoggedIn: {})
}

