//
//  PASpinner.swift
//  
//
//  Created by Stefania Castiglioni on 23/11/23.
//

import SwiftUI

public struct PASpinner: View {
    
    private var initialPoint: CGFloat
    private var rotation: Angle
    
    private var spinnerSize: SpinnerSize
    private var spinnerColor: Color

    @State private var lowerValue: CGFloat
    @State private var upperValue: CGFloat = 0.03
    @State private var rotationDegrees: Angle
    
    public enum SpinnerColor {
        case primary, white
    }
    
    public enum SpinnerSize {
        case large
        case cta
        
        var size: CGFloat {
            switch self {
            case .large:
                return 120.0
            case .cta:
                return 24.0
            }
        }
        
        var lineWidth: CGFloat {
            switch self {
            case .large:
                return 10.0
            case .cta:
                return 4.0
            }
        }
    }
    
    public init(size: SpinnerSize, color: Color) {
        
        self.spinnerSize = size
        self.spinnerColor = color
        
        initialPoint = 0
        rotation = .degrees(120)
        
        lowerValue = initialPoint
        rotationDegrees = rotation
    }
    
    let trackerRotation: Double = 2
    let animationDuration: Double = 0.6
    var totalDuration: Double { trackerRotation * animationDuration }
    
    public var body: some View {
        ZStack {
            Circle()
                .trim(from: lowerValue, to: upperValue)
                .stroke(gradient, style: StrokeStyle(
                    lineWidth: spinnerSize.lineWidth,
                    lineCap: .round,
                    lineJoin: .round))
                .frame(width: spinnerSize.size, height: spinnerSize.size)
                .rotationEffect(rotationDegrees)
                .onAppear {
                    Timer.scheduledTimer(withTimeInterval: totalDuration + 0.1, repeats: true) { _ in
                        self.animateLoader()
                    }.fire()
                }
        }
        .accessibilityIdentifier("spinner")
    }

    private var gradientColors: [Color] {
        return  [spinnerColor.opacity(0.2), spinnerColor.opacity(0.7), spinnerColor]
    }
    
    private var gradient: AngularGradient {
        return AngularGradient(
            gradient: Gradient(colors: gradientColors),
            center: .center,
            startAngle: .degrees(0),
            endAngle: .degrees(180)
        )
    }

    func getRotationAngle() -> Angle {
        return .degrees(360 * trackerRotation)  + rotation
    }
    
    func animateLoader() {

        withAnimation(.spring(response: totalDuration)) {
//            rotationDegrees = rotation
            upperValue      = 0.15
        }
        
        Timer.scheduledTimer(withTimeInterval: animationDuration * 1.15, repeats: false) { _ in
            withAnimation(.easeInOut(duration: totalDuration)) {
                self.rotationDegrees = self.getRotationAngle()
            }
        }

        Timer.scheduledTimer(withTimeInterval: animationDuration * 0.8, repeats: false) { _ in

            withAnimation(.easeOut(duration: animationDuration + 0.05)) {
                upperValue = 0.75
            }
        }

        Timer.scheduledTimer(withTimeInterval: totalDuration, repeats: false) { _ in
            rotationDegrees = rotation
            
            withAnimation(.easeOut(duration: ( animationDuration))) {
                upperValue = 0.03
            }
        }
    }
}

struct LoaderModifier: ViewModifier {
    
    @Binding var isLoading: Bool
    
    var size: PASpinner.SpinnerSize
    var color: Color
    
    func body(content: Content) -> some View {
        content
            .overlay {
                if isLoading {
                    PASpinner(size: .cta, color: color)
                }
            }
    }
}

extension View {
    
    public func showLoader(size: PASpinner.SpinnerSize, color: Color, isLoading: Binding<Bool>) -> some View {
        self.modifier(LoaderModifier(isLoading: isLoading, size: size, color: color))
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
                Rectangle()
                    .fill(Color.paPrimary)
                    .frame(maxWidth: .infinity, maxHeight: 200)
                    .overlay {
                        HStack(spacing: 120) {
                            PASpinner(size: .cta, color: DarkTheme().spinnerSecondaryColor)
                            PASpinner(size: .large, color: DarkTheme().spinnerSecondaryColor)
                        }
                    }
            
                Rectangle()
                    .fill(Color.white)
                    .frame(maxWidth: .infinity, maxHeight: 200)
                    .overlay {
                        HStack(spacing: 120) {
                            PASpinner(size: .cta, color: LightTheme().spinnerSecondaryColor)
                            PASpinner(size: .large, color: LightTheme().spinnerSecondaryColor)
                        }
                    }
        }
    }
}
