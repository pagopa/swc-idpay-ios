//
//  BorderedTextFieldStyle.swift
//
//
//  Created by Stefania Castiglioni on 04/12/23.
//

import SwiftUI

struct BorderedTextFieldStyle: TextFieldStyle {

    @Environment(\.isEnabled) private var isEnabled
    @Binding var isEditing: Bool
    @Binding var text: String
    var placeholder: String
    var icon: Image.PAIcon? = nil
    @Binding var status: InputField.InputStatus

    func _body(configuration: TextField<Self._Label>) -> some View {
        HStack {
            if let icon {
                Image(icon: icon)
                    .foregroundColor(foregroundColor)
            }
            
            configuration
            
            if let rightIcon = status.icon {
                Image(icon: rightIcon)
            }
        }
        .font(.PAFont.body)
        .foregroundColor(foregroundColor)
        .padding(15)
        .overlay {
            RoundedRectangle(cornerRadius: Constants.radius1, style: .continuous)
                .stroke(strokeColor, lineWidth: 1)
        }
        .floatingLabel(
            title: placeholder,
            opacity: (isEditing || !text.isEmpty) ? 1.0 : 0.5,
            insets: EdgeInsets(top: 0, leading: (icon != nil) ? 30 : 0, bottom: 0, trailing: (status.icon != nil) ? 30 : 0),
            displaceLabel: !text.isEmpty ? .constant(true) : self.$isEditing
        )

    }
    
    private var foregroundColor: Color {
        guard isEnabled == true else { return Color.grey200.opacity(0.5) }
        return Color.paBlack
    }
    
    private var strokeColor: Color {
        guard isEnabled == true else { return Color.grey200 }
        switch status {
        case .success:
            return .success
        case .error:
            return .error
        default:
            return isEditing ? Color.paPrimary : Color.grey200
        }
    }
}
