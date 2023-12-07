//
//  ProgressDemoView.swift
//
//
//  Created by Stefania Castiglioni on 07/12/23.
//

import SwiftUI

public struct ProgressDemoView: View {
    
    public init() {}
    
    public var body: some View {
        ZStack {
            Color.infoLight
                
            VStack(spacing: 40) {
                PAProgressView(themeType: .light)
                    .padding(.horizontal, Constants.mediumSpacing)
                    .frame(maxHeight: 4)
                
                PAProgressView(themeType: .light)
                    .padding(.horizontal, Constants.mediumSpacing)
                    .frame(maxWidth: 200, maxHeight: 4)

            }
        }
    }
}

#Preview {
    ProgressDemoView()
}
