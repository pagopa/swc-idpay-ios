//
//  ProgressView.swift
//  
//
//  Created by Stefania Castiglioni on 29/11/23.
//

import SwiftUI

public struct PAProgressView: View {
    
    private var themeType: ThemeType
    private var theme: PagoPATheme
    private var animationDuration: Double = 2.0
    private var progress: Double = 1.0
    private var loaderWidth: CGFloat { 80 }

    @State private var xOffset: CGFloat = -120
    
    public init(themeType: ThemeType) {
        self.themeType = themeType
        self.theme = ThemeManager.buildTheme(type: themeType)
    }
    
    public var body: some View {
        GeometryReader { proxy in
            VStack {
                ZStack {
                    Rectangle()
                        .fill(theme.progressBarBkgColor)
                        .frame(width: proxy.size.width, height: 4)
                    
                    Rectangle()
                        .fill(theme.progressBarColor)
                        .cornerRadius(5.0)
                        .frame(width: proxy.size.width/2.0, height: 4)
                        .offset(x: xOffset)
                }
            }
            .mask(Rectangle()
                .frame(width: proxy.size.width)
            )
            .onAppear {
                Timer.scheduledTimer(withTimeInterval: animationDuration, repeats: true) { _ in
                    self.animateProgress(proxy.size.width)
                }.fire()
            }
        }

    }
    
    private func animateProgress(_ width: CGFloat) {
        xOffset = loaderStartPosition(width)

        withAnimation(.spring(duration: animationDuration, blendDuration: animationDuration/2.0)) {
            xOffset = width
        }
    }
    
    private func loaderStartPosition(_ totalWidth: CGFloat) -> CGFloat {
        -(loaderWidth/2.0 + totalWidth/2.0)
    }
}

#Preview {
    ProgressDemoView()
}
