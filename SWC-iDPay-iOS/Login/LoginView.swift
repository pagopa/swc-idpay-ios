//
//  LoginView.swift
//
//
//  Created by Stefania Castiglioni on 22/12/23.
//

import SwiftUI
import PagoPAUIKit

struct LoginView: View {
    
    @State private var isLoading: Bool = false
    @ObservedObject var viewModel: LoginViewModel
    
    private var onLoggedIn: () -> Void = { }
    
    @State private var toastError: ToastModel? = nil
    @FocusState private var focusedField: Field?
    
    private enum Field: Int, CaseIterable, Hashable {
        case username, password, loginButton
    }
    
    init(viewModel: LoginViewModel, onLoggedIn: @escaping () -> Void) {
        self.viewModel = viewModel
        self.onLoggedIn = onLoggedIn
    }
    
    var body: some View {
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
    
    @ViewBuilder
    private var loginForm: some View {
        Form {
            InputField(type: .text, text: $viewModel.username, placeholder: "Username", autofocus: true)
                .focused($focusedField, equals: .username)
                .submitLabel(.next)
                .onSubmit {
                    focusedField = .password
                }
                .disabled(isLoading)
                .id(Field.username)
                .accessibilityIdentifier("Username textfield")
            
            InputField(type: .password, text: $viewModel.password, placeholder: "Password", autofocus: false)
                .focused($focusedField, equals: .password)
                .submitLabel(.done)
                .disabled(isLoading)
                .onSubmit {
                    guard viewModel.isFormValid else { return }
                    submitForm()
                }
                .id(Field.password)
                .accessibilityIdentifier("Password textfield")
            
            CustomLoadingButton(buttonType: .primary, isLoading: $isLoading) {
                submitForm()
            } label: {
                Text("Accedi")
            }
            .disabled(!viewModel.isFormValid)
            .padding(.vertical, Constants.smallSpacing)
            .id(Field.loginButton)
        }
        .formStyle(.columns)
        .padding(.horizontal, Constants.smallSpacing)
        
    }
    
    private func submitForm() {
        focusedField = nil
        Task {
            isLoading = true
            let isUserLoggedIn = await viewModel.login()
            isLoading = false
            
            if isUserLoggedIn {
                onLoggedIn()
            } else {
                toastError = ToastModel(style: .error, message: "Accesso non riuscito. Hai inserito il nome utente e la password corretti?")
            }
        }
    }
}

#Preview {
    LoginView(viewModel: LoginViewModel(), onLoggedIn: {})
}

