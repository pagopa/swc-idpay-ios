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
        case thankyouPage
        
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
            case .thankyouPage:
                return "Thankyou Page"
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
            case .thankyouPage:
                EmptyView()
            }
        }
    }
}


struct ComponentsDemoListView: View {
    
    @State var menuIconOpacity: CGFloat = 0.0
    @State var themeType: ThemeType?
    @State var navigateToThankyouPage: Bool = false
    @State var showThankyouPageChoiceAlert: Bool = false
    
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
                    if component.type == .thankyouPage {
                            Button {
                                showThankyouPageChoiceAlert.toggle()
                            } label: {
                                Text(component.type.name)
                                    .font(.PAFont.cta)
                                    .foregroundColor(.paPrimaryDark)
                            }
                        
                    } else {
                        NavigationLink(component.type.name, value: component)
                            .font(.PAFont.cta)
                            .foregroundColor(.paPrimaryDark)
                    }
                }
                .listStyle(.plain)
                .navigationDestination(for: Component.self) {
                    $0.type.viewDestination
                        .navigationBarTitleDisplayMode(.inline)
                }
                .navigationDestination(isPresented: $navigateToThankyouPage) {
                    if let themeType {
                        switch themeType {
                        case .error:
                            ErrorThankyouPageDemo()
                        case .success:
                            SuccessThankyouPageDemo()
                        case .info:
                            InfoThankyouPageDemo()
                        case .warning:
                            WarningThankyouPageDemo()
                        default:
                            EmptyView()
                        }
                    } else {
                        EmptyView()
                    }
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
        .alert("Thankyou page type", isPresented: $showThankyouPageChoiceAlert){
            
            VStack {
                Button("Success") {
                    showThankyouPage(.success)
                }
                Button("Error") {
                    showThankyouPage(.error)
                }
                Button("Info") {
                    showThankyouPage(.info)
                }
                Button("Warning") {
                    showThankyouPage(.warning)
                }
            }
        }
    }
    
    private func showThankyouPage(_ themeType: ThemeType) {
        self.themeType = themeType
        navigateToThankyouPage = true
        showThankyouPageChoiceAlert.toggle()
    }
}


#Preview {
    ComponentsDemoListView()
}
