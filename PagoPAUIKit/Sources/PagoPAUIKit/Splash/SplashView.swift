//
//  SplashView.swift
//
//
//  Created by Stefania Castiglioni on 01/12/23.
//

import SwiftUI

public struct SplashView: View {
    @State private var iconOpacity: Double = 0.0
    private var onComplete: () -> Void = { }
    private var outAnimationTime = 3.0
    private var inAnimationTime = 1.0
    
    public init(onComplete: @escaping () -> Void) {
        self.onComplete = onComplete
    }
    
    public var body: some View {
        ZStack {
            Color.paPrimary
            Image(icon: .idPayLogo)
                .foregroundColor(.white)
                .opacity(iconOpacity)
        }
        .ignoresSafeArea()
        .onAppear {
            animateLogo()
            DispatchQueue.main.asyncAfter(deadline: .now() + outAnimationTime + inAnimationTime) {
                onComplete()
            }
        }
    }
    
    func animateLogo() {
        withAnimation(.easeIn(duration: inAnimationTime)) {
            iconOpacity = 1.0
        }

        Timer.scheduledTimer(withTimeInterval: outAnimationTime, repeats: false) { timer in
            withAnimation(.easeOut(duration: 1.0)) {
                iconOpacity = 0.0
            }
        }
    }
}

#Preview {
    SplashView(onComplete: {})
}
