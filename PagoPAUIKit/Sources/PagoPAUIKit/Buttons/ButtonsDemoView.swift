//
//  ButtonsDemoView.swift
//
//
//  Created by Stefania Castiglioni on 06/12/23.
//

import SwiftUI

public struct ButtonsDemoView: View {
    public init() {}
    public var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                
                ButtonsDemoSection(title: "Dark", themeType: .dark)
                Divider(color: .white)

                ButtonsDemoSection(title: "Light", themeType: .light)
                Divider(color: .grey200)

                ButtonsDemoSection(title: "Info", themeType: .info)
                Divider(color: .paPrimary)
                
                ButtonsDemoSection(title: "Success", themeType: .success)
                Divider(color: .successDark)

                ButtonsDemoSection(title: "Error", themeType: .error)
                Divider(color: .errorDark)

                ButtonsDemoSection(title: "Warning", themeType: .warning)
                Divider(color: .warningDark)

            }
        }
        .scrollIndicators(.hidden)
    }
}

struct ButtonsDemoSection: View {
    
    var title: String
    var themeType: ThemeType
    private var theme: PagoPATheme
    
    init(title: String, themeType: ThemeType){
        self.title = title
        self.themeType = themeType
        self.theme = ThemeManager.buildTheme(type: themeType)
    }
    
    var body: some View {
        VStack(spacing: Constants.mediumSpacing) {
            Text(title)
                    .font(.PAFont.h1)
                    .foregroundColor(theme.primaryButtonBkgColor)
            LoadingButtonView(title: "Loading primary", buttonType: .primary, themeType: themeType)
            LazyLoadingButtonView(title: "Lazy loading secondary", buttonType: .secondary, themeType: themeType)
            
            BaseButtonView(
                title: "Left icon button",
                icon: .star,
                themeType: themeType)
            
            BaseButtonView(
                title: "Right icon button",
                icon: .star,
                position: .right,
                themeType: themeType)
            
            BaseButtonView(
                title: "Secondary icon button",
                type: .primaryBordered,
                icon: .star,
                themeType: themeType)
            
            BaseButtonView(
                title: "Plain button",
                type: .plain,
                themeType: themeType)

        }
        .padding(.vertical, Constants.largeSpacing)
        .background(theme.backgroundColor)
        .frame(maxWidth: .infinity)

    }
}

struct BaseButtonView: View {
    
    var title: String
    var type: PagoPAButtonType = .primary
    var icon: Image.PAIcon?
    var position: ImagePosition = .left
    var themeType: ThemeType

    var body: some View {
        Button {
        } label: {
            Text(title)
        }
        .pagoPAButtonStyle(
            buttonType: type,
            icon: icon,
            position: position,
            themeType: themeType)
        .padding(.horizontal, Constants.mediumSpacing)

    }
}

struct LazyLoadingButtonView: View {
    
    var title: String
    var buttonType: PagoPAButtonType
    var icon: Image.PAIcon?
    var position: ImagePosition = .left
    var themeType: ThemeType
    @State var isLoading: Bool = false
    
    var body: some View {
        CustomLazyLoadingButton(
            buttonType: buttonType,
            icon: icon,
            position: position,
            themeType: themeType,
            isLoading: $isLoading,
            action: {
                Task {
                    await loadData()
                }
            }, label: {
                Text(title)
            }
        )
        .padding(.horizontal,Constants.mediumSpacing)

    }
    
    private func loadData() async {
        isLoading = true
        try? await Task.sleep(nanoseconds: 1 * 4_000_000_000)
        isLoading = false
    }

}


struct LoadingButtonView: View {
    
    var title: String
    var buttonType: PagoPAButtonType
    var icon: Image.PAIcon?
    var position: ImagePosition = .left
    var themeType: ThemeType
    @State var isLoading: Bool = false
    
    var body: some View {
        CustomLoadingButton(
            buttonType: buttonType,
            icon: icon,
            position: position,
            themeType: themeType,
            isLoading: $isLoading,
            action: {
                Task {
                    await loadData()
                }
            }, label: {
                Text(title)
            }
        )
        .padding(.horizontal,Constants.mediumSpacing)

    }
    
    private func loadData() async {
        isLoading = true
        try? await Task.sleep(nanoseconds: 1 * 4_000_000_000)
        isLoading = false
    }

}

#Preview {
    ButtonsDemoView()
}
