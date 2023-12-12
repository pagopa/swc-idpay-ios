//
//  ListItemHistory.swift
//
//
//  Created by Pier Domenico Bonamassa on 12/12/23.
//

import SwiftUI

public struct ListItemHistory: View {
    var iconLeft: Image.PAIcon?
    var titleText: String
    var subTitleText: String
    var amountText: String?
    
    public init(iconLeft: Image.PAIcon? = nil, titleText: String, subTitleText: String, amountText: String? = nil) {
        self.iconLeft = iconLeft
        self.titleText = titleText
        self.subTitleText = subTitleText
        self.amountText = amountText
    }
    
    public var body: some View {
        HStack{
            HStack{
                if let leftIcon = iconLeft{
                    Image(icon:leftIcon)
                        .padding(.trailing, 4)
                }
                VStack(alignment: .leading){
                    Text(titleText)
                        .font(.PAFont.bodySB)
                        .foregroundColor(Color.paBlack)
                    
                    Text(subTitleText)
                        .font(.PAFont.caption)
                        .foregroundColor(Color.grey650)
                }
            }
            Spacer()
            
            if let amount = amountText{
                Text(amount)
                    .font(.PAFont.h6)
                    .foregroundColor(Color.paBlack)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Spacings.medium.rawValue/2.0)
    }
}

#Preview {
    ScrollView {
        ListItemHistory(iconLeft: .checkmark ,titleText: "title", subTitleText: "subtitle", amountText: "151,00 €")
        Divider()
        
        ListItemHistory(iconLeft: .warning ,titleText: "title", subTitleText: "subtitle", amountText: "151,00 €")
        Divider()
        
        ListItemHistory(iconLeft: .pending ,titleText: "title", subTitleText: "subtitle", amountText: "151,00 €")
        Divider()
        
        ListItemHistory(iconLeft: .refunded ,titleText: "title", subTitleText: "subtitle", amountText: "151,00 €")
        Divider()
        
        ListItemHistory(iconLeft: .toBeRefunded ,titleText: "title", subTitleText: "subtitle", amountText: "151,00 €")
        Divider()
        
    }
    .padding(.horizontal, Spacings.medium.rawValue)
    
}
