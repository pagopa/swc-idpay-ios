//
//  ToastModifier.swift
//  
//
//  Created by Pier Domenico Bonamassa on 13/12/23.
//

import SwiftUI

struct ToastModifier: ViewModifier {
    
    @Binding var toast: ToastModel?
    @State private var scale = 0.8
    @State private var opacity = 0.0
    @State private var workItem: DispatchWorkItem?
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(
                Group {
                    if let toast = toast {
                        VStack {
                            Spacer()
                            ToastNotification(
                                style: toast.style,
                                message: toast.message
                            )
                            .opacity(opacity)
                            .scaleEffect(scale)
                        }
                    }
                }
            )
            .onChange(of: toast) { value in
                animateToast()
            }
    }
    
    private func animateToast() {
        
        guard let toast = toast else {
            scale = 0.8
            opacity = 0.0
            return
        }
        
        withAnimation(.easeIn(duration: 0.5)) {
            scale = 1.0
            opacity = 1.0
        }
        
        workItem?.cancel()
        
        let task = DispatchWorkItem {
            dismissToast()
        }
        
        workItem = task
        
        DispatchQueue.main.asyncAfter(deadline: .now() + toast.duration + 1.0, execute: task)
    }
    
    private func dismissToast() {
        withAnimation(.easeOut(duration: 0.5)) {
                //            scale = 0.5
            opacity = 0.0
            toast = nil
        }
        
        workItem?.cancel()
        workItem = nil
    }
}

extension View {
    
    public func toastView(toast: Binding<ToastModel?>) -> some View {
        self.modifier(ToastModifier(toast: toast))
    }
}

extension AnyTransition {
    static var zoomAndFade: AnyTransition {
        .asymmetric(
            insertion: AnyTransition.opacity.animation(.easeIn(duration: 1.0)).combined(with: .scale),
            removal:   .opacity.animation(.easeOut(duration: 0.6))
        )
    }
}
