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
    var icon: Image.PAIcon?
    var duration: Double = 1.5
    var width: Double = .infinity
    var theme: PagoPATheme?
    
    public static func == (lhs: ToastModel, rhs: ToastModel) -> Bool {
        return lhs.id == rhs.id
    }
}
