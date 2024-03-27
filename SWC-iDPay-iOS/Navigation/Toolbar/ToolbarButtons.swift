//
//  ToolbarButtons.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 20/12/23.
//

import SwiftUI
import PagoPAUIKit

// MARK: - Custom toolbar buttons
struct BackButton: View {
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Image(icon: .arrowLeft)
        }
    }
}

struct HamburgerMenuButton: View {
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Image(icon: .menu)
        }
    }
}


struct HomeButton: View {
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Image(icon: .home)
        }
    }
}

