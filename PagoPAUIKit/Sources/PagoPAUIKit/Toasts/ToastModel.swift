//
//  ToastModel.swift
//
//
//  Created by Pier Domenico Bonamassa on 13/12/23.
//

import SwiftUI

public struct ToastModel: Equatable {
    var id = UUID()
    var style: ToastStyle
    var message: String
    var duration: Double = 3.0
    var theme: PagoPATheme?
    
    public init(style: ToastStyle, message: String, duration: Double = 1.5) {
        self.style = style
        self.message = message
        self.duration = duration
    }
    
    public static func == (lhs: ToastModel, rhs: ToastModel) -> Bool {
        return lhs.id == rhs.id
    }
}
