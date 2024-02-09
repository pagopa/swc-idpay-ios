//
//  Loader.swift
//  
//
//  Created by Stefania Castiglioni on 29/11/23.
//

import SwiftUI

extension View {
    
    public func showLoadingView(message: String, isLoading: Binding<Bool>) -> some View {
        self.modifier(Loader(text: message, isLoading: isLoading))
    }
}

struct Loader: ViewModifier {
    var text: String
    @Binding var isLoading: Bool
    @State private var showLoader: Bool = false
    
    func body(content: Content) -> some View {
        content
            .onChange(of: isLoading) { newValue in
                var transaction = Transaction()
                transaction.disablesAnimations = true
                withTransaction(transaction) {
                    showLoader = newValue
                }
            }
            .fullScreenCover(isPresented: $showLoader) {
                    ZStack {
                        Color.white
                            .ignoresSafeArea()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        
                        VStack {
                            PALoaderAnimationView()
                                .frame(maxWidth: Constants.loaderSize, maxHeight: Constants.loaderSize)
                            
                            Text(text)
                                .font(.PAFont.h3)
                                .foregroundColor(.paBlack)
                                .padding(.horizontal, Constants.mediumSpacing)
                                .multilineTextAlignment(.center)
                        }
                    }
            }
    }
}

// MARK: Demo View
public struct LoadingView: View {
    @State var inProgress: Bool = false
    
    public init() {}
    
    public var body: some View {
        VStack {
            Button {
                loadData()
            } label: {
                Text("Start loading..")
            }
            .pagoPAButtonStyle(buttonType: .primary)
            .padding(.horizontal, 24)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.infoLight)
        .showLoadingView(message: "Stiamo verificando il tuo portafoglio ID Pay", isLoading: $inProgress)
        
    }
    
    private func loadData() {
        inProgress.toggle()
        DispatchQueue.main.asyncAfter(deadline: .now()+5) {
            inProgress.toggle()
        }
    }
}


struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
