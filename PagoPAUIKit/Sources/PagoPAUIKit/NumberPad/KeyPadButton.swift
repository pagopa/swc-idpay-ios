//
//  KeyPadButton.swift
//  
//
//  Created by Stefania Castiglioni on 18/01/24.
//

import SwiftUI

struct KeyPadButton: View {
    var key: String
    var icon: Image.PAIcon?

    @Environment(\.keyPadButtonAction) var action: (String) -> Void

    init(_ key: String, icon: Image.PAIcon? = nil) {
        self.key = key
        self.icon = icon
    }
    
    var body: some View {
        Button {
            self.action(self.key)
        } label: {
            if let icon = icon {
                Image(icon: icon)
            } else {
                Text(key)
            }
        }
        .padding()
        .buttonStyle(KeyPadButtonStyle())
    }
    
    enum NumberActionKey: EnvironmentKey {
        static var defaultValue: (String) -> Void { { _ in } }
    }

}

extension EnvironmentValues {
    var keyPadButtonAction: (String) -> Void {
        get { self[KeyPadButton.NumberActionKey.self] }
        set { self[KeyPadButton.NumberActionKey.self] = newValue }
    }
}


struct KeyPadButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Self.Configuration) -> some View {
        ZStack {
            Circle()
                .fill(configuration.isPressed ? Color.grey200 : Color.grey50)
                .frame(width: 56, height: 56.0)
            configuration.label
                .font(.PAFont.h3)
                .foregroundColor(.paPrimary)
        }
        
    }
}

