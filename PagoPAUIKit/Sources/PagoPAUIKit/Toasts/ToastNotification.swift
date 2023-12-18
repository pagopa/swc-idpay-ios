//
//  ToastNotification.swift
//
//
//  Created by Pier Domenico Bonamassa on 13/12/23.
//

import SwiftUI

public struct ToastNotification: View {
    private var icon: Image.PAIcon?
    private var message: String
    private var width = CGFloat.infinity
    private var theme: PagoPATheme
    
    init(style: ToastStyle, message: String) {
        self.theme = style.theme
        self.icon = style.icon
        self.message = message
    }
    
    public var body: some View {
        HStack(alignment: .center, spacing: 8){
            Text(message)
                .font(.PAFont.cta)
                .foregroundColor(theme.toastTextBorderBkgColor)
            Spacer()
            if let icon = self.icon {
                Image(icon: icon)
                    .resizable()
                    .frame(width: Constants.listItemIconSize, height: Constants.listItemIconSize)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 8)
                .fill(theme.toastBackgroundColor)
        }
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(theme.toastTextBorderBkgColor, lineWidth: 2)
        )
        .padding(.horizontal, Constants.smallSpacing)
    }
}

public struct ToastDemoView: View {
    
    @State var toast: ToastModel? = nil
    @State var loading: Bool = false
    
    public init() {}
   public var body: some View {
       ScrollView {
           VStack {
               CustomLoadingButton(buttonType: .primary, isLoading: $loading) {
                   Task {
                       await loadData()
                   }
                   
               } label: {
                   Text("Show animated toast")
                   
               }
               .padding(Constants.mediumSpacing)
           }
           
           VStack(spacing: Constants.smallSpacing) {
               ToastNotification(style: .neutral, message: "Lorem ipsum dolor sit amet")
               
               ToastNotification(style: .neutralIcon, message: "Lorem ipsum dolor sit amet")
               
               ToastNotification(style: .infoFilled, message: "Lorem ipsum dolor sit amet")
               
               ToastNotification(style: .error, message: "Fatal error, blue screen level fatal l")
               
               ToastNotification(style: .success, message: "Lorem ipsum dolor sit amet, consectetur adipiscing elit")
               ToastNotification(style: .warning, message: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus sit amet nulla congue odio euismod")

           }
       }
       .background(.white)
       .toastView(toast: $toast)
    }
    
    private func loadData() async {
        toast = nil
        loading = true
        try? await Task.sleep(nanoseconds: 1 * 2_000_000_000)
        loading = false
        showRandomToast(style: ToastStyle.allCases.randomElement() ?? .neutral)
    }
    
    private func showRandomToast(style: ToastStyle) {
        toast = ToastModel(style: style, message: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus sit amet nulla congue odio euismod")
    }
}

#Preview {
    
    ToastDemoView()

//    VStack {
//        ToastNotification(style: .neutral, message: "Lorem ipsum dolor sit amet")
//        
//        ToastNotification(style: .neutralIcon, message: "Lorem ipsum dolor sit amet")
//        
//        ToastNotification(style: .infoFilled, message: "Lorem ipsum dolor sit amet")
//        
//        ToastNotification(style: .error, message: "Fatal error, blue screen level fatal l")
//        
//        ToastNotification(style: .success, message: "Lorem ipsum dolor sit amet, consectetur adipiscing elit")
//        ToastNotification(style: .warning, message: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus sit amet nulla congue odio euismod")
//        
//    }
}
