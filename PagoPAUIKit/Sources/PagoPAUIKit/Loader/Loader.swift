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
    
    func body(content: Content) -> some View {
        content
            .overlay {
                if isLoading {
                    ZStack {
                        Color.white
                            .ignoresSafeArea()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        
                        VStack {
                            PALoaderAnimationView()
                                .frame(maxWidth: 64, maxHeight: 64)
                            
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
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Color.paPrimary
        }
        .showLoadingView(message: "Stiamo verificando il tuo portafoglio ID Pay", isLoading: .constant(true))

    }
}
