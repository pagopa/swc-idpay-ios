//
//  View+FloatingLabelModifier.swift
//
//
//  Created by Stefania Castiglioni on 04/12/23.
//

import SwiftUI

public struct FloatingLabelModifier: ViewModifier {
    
    var title: String
    var opacity: Double = 1.0
    var insets: EdgeInsets

    @Binding var displaceLabel: Bool

    public init(title: String, opacity: Double, insets: EdgeInsets = EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0), displaceLabel: Binding<Bool>) {
        self.title = title
        self.opacity = opacity
        self.insets = insets
        _displaceLabel = displaceLabel
    }
    
    public func body(content: Content) -> some View {
        content
            .overlay(alignment: .center) {
                GeometryReader { proxy in
                    Text(title)
                        .font(.PAFont.body)
                        .foregroundColor(.grey700.opacity(opacity))
                        .background{
                            if displaceLabel == true {
                                Rectangle()
                                    .inset(by: -5.0)
                                    .fill(Color.white)
                            }
                        }
                        .padding(.leading, insets.leading)
                        .padding(.trailing, insets.trailing)
                        .offset(y: displaceLabel == false ? 0 : -(proxy.size.height/2.0 + 7))
                        .offset(x: displaceLabel == true ? -insets.leading : 0)
                        .scaleEffect(displaceLabel == false ? 1 : 0.8, anchor: .leading)
                        .frame(height: proxy.size.height)
                        .padding(.horizontal, 15)
                        .animation(.spring, value: displaceLabel)
                        .allowsHitTesting(false)
                }
            }
    }

}

extension View {
    
    public func floatingLabel(title: String, opacity: Double, insets: EdgeInsets = EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0),  displaceLabel: Binding<Bool>) -> some View {
        modifier(FloatingLabelModifier(title: title, opacity: opacity, insets: insets, displaceLabel: displaceLabel))
    }
}
