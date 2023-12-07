//
//  ProgressView.swift
//  
//
//  Created by Stefania Castiglioni on 29/11/23.
//

import SwiftUI

struct ProgressView: View {
    
    var themeType: ThemeType
    private var theme: PagoPATheme
    private var animationDuration: Double = 1.0
    private var progress: Double = 1.0
    private var loaderWidth: CGFloat { 80 }

    @State var xOffset: CGFloat = -120
    
    init(themeType: ThemeType) {
        self.themeType = themeType
        self.theme = ThemeManager.buildTheme(type: themeType)
    }
    
    var body: some View {
        GeometryReader { proxy in
            VStack {
                ZStack {
                    Rectangle()
                        .fill(theme.progressBarBkgColor)
                        .frame(width: proxy.size.width, height: 4)
                    
                    Rectangle()
                        .fill(theme.progressBarColor)
                        .cornerRadius(5.0)
                        .frame(width: loaderWidth, height: 4)
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
    
    func animateProgress(_ width: CGFloat) {
        xOffset = loaderStartPosition(width)

        withAnimation(.easeInOut(duration: animationDuration)) {
            xOffset = width
        }
    }
    
    private func loaderStartPosition(_ totalWidth: CGFloat) -> CGFloat {
        -(loaderWidth/2.0 + totalWidth/2.0)
    }
}

struct ProgressView_Previews: PreviewProvider {
    static var previews: some View {
        
        ZStack {
            Color.infoLight
                
            VStack {
                ProgressView(themeType: .light)
                    .padding(.horizontal, Constants.mediumSpacing)
                    .frame(maxWidth: .infinity, maxHeight: 4)

            }
        }
    }
}
