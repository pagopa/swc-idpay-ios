//
//  MenuView.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 17/01/24.
//

import SwiftUI
import PagoPAUIKit

struct MenuView: View {
    @Binding var showMenu: Bool
    @Binding var showHelp: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: Constants.xxlargeSpacing) {
            
            VStack(alignment: .leading, spacing: 0) {
                MenuItem(title: "Accetta bonus ID Pay", icon: .bonus, showMenu: $showMenu) {
                    
                }
                Divider()
                
                MenuItem(title: "Storico operazioni", icon: .transactions, showMenu: $showMenu) {
                    
                }
                Divider()
                
                MenuItem(title: "Assistenza", icon: .faq, showMenu: $showMenu) {
                    showHelp.toggle()
                }
            }
            
            MenuItem(title: "Esci", icon: .logout, color: .errorGraphic, showMenu: $showMenu) {
            }
            .padding(.bottom, Constants.mediumSpacing)
        }
        .padding(.horizontal, Constants.mediumSpacing)
    }
    
}

private struct MenuItem: View {
    
    var title: String
    var icon: Image.PAIcon
    var color: Color = .paBlack
    @Binding var showMenu: Bool
    var action: () -> Void
    
    var body: some View {
        Button {
            showMenu.toggle()
            action()
        } label: {
            HStack {
                Image(icon: icon)
                Text(title)
                    .font(.PAFont.cta)
            }
        }
        .foregroundColor(color)
        .padding(.top, 14)
        .padding(.bottom, 12)
        .accessibilityIdentifier("menu item")
    }
}

struct MenuDemoView: View {
    
    @State var showSheet: Bool = false
    @State var showHelp: Bool = false

    var body: some View {
        ZStack {
            Color.yellow
            
            VStack {
                Text("Sheet it!")
                Button {
                    showSheet.toggle()
                } label: {
                    Text("Show")
                }
            }
        }
        .showSheet(isVisibile: $showSheet) {
            MenuView(showMenu: $showSheet, showHelp: $showHelp)
        }
    }
}

#Preview {
    VStack {
        MenuView(showMenu: .constant(true), showHelp: .constant(false))
    }
}

#Preview {
    MenuDemoView()
}
