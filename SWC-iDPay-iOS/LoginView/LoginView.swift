//
//  LoginView.swift
//
//
//  Created by Stefania Castiglioni on 22/12/23.
//

import SwiftUI
import PagoPAUIKit

public struct LoginView: View {
    
    @State var username: String = ""
    @State var password: String = ""
    @State private var isLoading: Bool = false
    
    private var onLoggedIn: () -> Void = { }
    @State private var toastError: ToastModel? = nil
    @FocusState private var focusedField: Field?
    
    private enum Field: Int, CaseIterable, Hashable {
        case username, password, loginButton
    }
    
    public init(onLoggedIn: @escaping () -> Void) {
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
                        Image(icon: .idPayLogo)
                            .foregroundColor(.paPrimary)
                        
                        Text("Ambiente di test")
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
            .toastView(toast: $toastError)
        }
    }
    
    #warning("Add network call to login")
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
                .accessibilityIdentifier("Username textfield")
            
            InputField(type: .password, text: $password, placeholder: "Password", autofocus: false)
                .focused($focusedField, equals: .password)
                .submitLabel(.done)
                .disabled(isLoading)
                .onSubmit {
                    guard isFormValid else { return }
                    submitForm()
                }
                .id(Field.password)
                .accessibilityIdentifier("Password textfield")

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
                toastError = ToastModel(style: .error, message: "Accesso non riuscito. Hai inserito il nome utente e la password corretti?")
            }
        }
    }
    
    private var isFormValid: Bool {
        !(username.isEmpty || password.isEmpty)
    }
}

#Preview {
    LoginView(onLoggedIn: {})
}

