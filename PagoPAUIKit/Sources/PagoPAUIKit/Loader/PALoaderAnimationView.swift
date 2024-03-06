//
//  PALoaderAnimation.swift
//  
//
//  Created by Stefania Castiglioni on 28/11/23.
//

import SwiftUI
import Lottie

struct PALoaderAnimationView: UIViewRepresentable {
    
    func makeUIView(context: UIViewRepresentableContext<PALoaderAnimationView>) -> UIView {
        let view = UIView(frame: .zero)
        let animationView = LottieAnimationView(name: "pagopa_loader", bundle: .module)
        animationView.loopMode = .loop
        animationView.play()
        animationView.contentMode = .scaleAspectFit
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

struct PALoaderDemo: View {
    
    @State var inProgress: Bool = false
    
    var body: some View {
        ZStack {
            if inProgress {
                PALoaderAnimationView()
                    .frame(maxWidth: 64, maxHeight: 64)
            }

            VStack {
                Spacer()

                Button {
                    inProgress.toggle()
                    DispatchQueue.main.asyncAfter(deadline: .now()+5) {
                        inProgress.toggle()
                    }
                } label: {
                    Text("Load")
                }
                .pagoPAButtonStyle(buttonType: .primary)
                .padding(24)
                .disabled(inProgress)
            }
            
        }
    }
}

struct PALoaderDemo_Previews: PreviewProvider {
    static var previews: some View {
        PALoaderDemo()
    }
}
