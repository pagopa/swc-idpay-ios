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
        case colors
        
        var name: String {
            switch self {
            case .colors:
                return "Colori"
            }
        }
        
        @ViewBuilder
        var viewDestination: some View {
            switch self {
            case .colors:
                ColorsDemoView()
            }
        }
    }
}

struct ComponentsDemoListView: View {
    
    private var components: [Component] =
        Component.ComponentType.allCases.map {
            Component(type: $0)
        }
    
    
    var body: some View {
        NavigationStack {
            List(components) { component in
                NavigationLink(component.type.name, value: component)
                
            }
            .navigationTitle("UI Kit - Components")
            .navigationDestination(for: Component.self) {
                $0.type.viewDestination
            }
            .background(Color.paPrimary)
            
        }
    }
}

#Preview {
    ComponentsDemoListView()
}
