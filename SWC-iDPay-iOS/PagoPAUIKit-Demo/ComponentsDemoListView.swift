//
//  ComponentsDemoListView.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 01/12/23.
//

import SwiftUI
import PagoPAUIKit

struct Component: Identifiable, Hashable {
    
    let id = UUID()
    let type: ComponentType
    
    enum ComponentType: CaseIterable {
        case buttons
        case colors
        case progress
        case listItem
        case toastNotification
        case input
        
        var name: String {
            switch self {
            case .buttons:
                return "Buttons"
            case .colors:
                return "Colors"
            case .progress:
                return "Progress"
            case .listItem:
                return "Items"
            case .toastNotification:
                return "Toast notification"
            case .input:
                return "Input"
            }
        }
        
        @ViewBuilder
        var viewDestination: some View {
            switch self {
            case .buttons:
                ButtonsDemoView()
            case .colors:
                ColorsDemoView()
            case .progress:
                ProgressDemoView()
            case .listItem:
                ItemsDemoView()
            case .toastNotification:
                ToastDemoView()
            case .input:
                InputDemoView()
            }
        }
    }
}


struct ComponentsDemoListView: View {
    
    @State var menuIconOpacity: CGFloat = 0.0

    private var components: [Component] =
        Component.ComponentType.allCases.map {
            Component(type: $0)
        }
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("UI Kit showcase")
                    .font(.PAFont.h1Hero)
                    .foregroundColor(.white)
                List(components) { component in
                    NavigationLink(component.type.name, value: component)
                        .font(.PAFont.cta)
                        .foregroundColor(.paPrimaryDark)
                }
                .listStyle(.plain)
                .navigationDestination(for: Component.self) {
                    $0.type.viewDestination
                        .navigationBarTitleDisplayMode(.inline)
                }
                
            }
            .background(Color.paPrimary)
            .navigationBarTitle("", displayMode: .inline)
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    Button{
                        print("Show menu")
                    } label: {
                        Image(icon: .menu)
                            .foregroundColor(.white)
                    }
                    .opacity(menuIconOpacity)
                }
                
            })
        }
        .onAppear {
            withAnimation(.easeIn(duration: 2.0)) {
                menuIconOpacity = 1.0
            }
        }
    }
}

#Preview {
    ComponentsDemoListView()
}
