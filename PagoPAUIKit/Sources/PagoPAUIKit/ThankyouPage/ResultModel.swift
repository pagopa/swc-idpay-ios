//
//  ResultModel.swift
//
//
//  Created by Pier Domenico Bonamassa on 19/12/23.
//

import SwiftUI

public struct ResultModel {
    var title: String?
    var subtitle: String?
    var icon: Image.PAIcon?
    var themeType: ThemeType
    var theme: PagoPATheme
    var buttons: [ButtonModel]
    var showLoading: Bool?
    
    public init(title: String? = nil, subtitle: String? = nil, icon: Image.PAIcon? = nil, themeType: ThemeType, buttons: [ButtonModel], showLoading: Bool? = nil) {
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.themeType = themeType
        self.theme = ThemeManager.buildTheme(type: themeType)
        self.buttons = buttons
        self.showLoading = showLoading
    }
}
