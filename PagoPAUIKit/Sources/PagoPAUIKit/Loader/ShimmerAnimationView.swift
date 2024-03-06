//
//  ShimmerView.swift
//  
//
//  Created by Stefania Castiglioni on 28/11/23.
//

import SwiftUI
import Lottie

struct ShimmerAnimationView: UIViewRepresentable {
    
    func makeUIView(context: UIViewRepresentableContext<ShimmerAnimationView>) -> UIView {
        
        let view = UIView(frame: .zero)

        let animationView = LottieAnimationView(name: "lazy_load_shimmer", bundle: .module)
            
        animationView.loopMode = .loop
        animationView.contentMode = .scaleAspectFill
        animationView.play()
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}

struct ShimmerView_Previews: PreviewProvider {
    static var previews: some View {
        
            Rectangle()
                .foregroundColor(.clear)
                .cornerRadius(40)
                .overlay {
                    ShimmerAnimationView()
                        .cornerRadius(40)
                        .padding(.horizontal, 24)
                        .frame(maxWidth: 140, minHeight: 16, maxHeight: 16)
                }
        
    }
}
