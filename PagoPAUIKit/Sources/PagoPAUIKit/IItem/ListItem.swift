//
//  ListItem.swift
//  
//
//  Created by Pier Domenico Bonamassa on 12/12/23.
//

import SwiftUI

public struct ListItem: View {
    var iconLeft: Image.PAIcon?
    var titleText: String
    var subTitleText: String
    var status: OperationStatus?
    var iconButtonRight: Image.PAIcon?
    var amountText: String?
    var actionButtonRight: (() -> Void)?
    
    public init(iconLeft: Image.PAIcon? = nil, title: String, subtitle: String, status: OperationStatus? = nil, icon: Image.PAIcon? = nil, amount: String? = nil, actionButtonRight: (() -> Void)? = nil ) {
        self.iconLeft = iconLeft
        self.titleText = title
        self.subTitleText = subtitle
        self.status = status
        self.iconButtonRight = icon
        self.amountText = amount
        self.actionButtonRight = actionButtonRight
    }
    
    public var body: some View {
        VStack {
            HStack{
                HStack{
                    if let iconLeft = iconLeft {
                        Image(icon: iconLeft)
                            .padding(.trailing, 4)
                    }
                    
                    VStack(alignment: .leading){
                        Text(titleText)
                            .lineLimit(1)
                            .font(.PAFont.caption)
                            .foregroundColor(Color.grey650)
                            .textCase(.uppercase)
                        Text(subTitleText)
                            .lineLimit(1)
                            .font(.PAFont.body)
                            .foregroundColor(Color.paBlack)
                    }
                }
                Spacer()
                if let buttonIcon = iconButtonRight {
                    Button {
                        actionButtonRight?()
                    } label: {
                        Image(icon: buttonIcon)
                    }
                    
                } else if let amount = amountText{
                    Text(amount)
                        .font(.PAFont.h6)
                        .foregroundColor(Color.paBlack)
                    
                } else if let status = status {
                    OperationStatusLabel(status: status)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Spacings.medium.rawValue/2.0)
    }
}

#Preview {
    ScrollView {
        ListItem(title: "Titolo", subtitle: "Sottotitolo")
        Divider()
        
        ListItem(title: "Titolo", subtitle: "Sottotitolo", icon: .info){
            print("pippo")
        }
        Divider()
        
        ListItem(iconLeft: .icoEuro, title: "Titolo", subtitle: "Sottotitolo")
        Divider()
        
        ListItem(iconLeft: .icoEuro, title: "Titolo", subtitle: "Sottotitolo", icon: .info){
            print("pippo")
        }
        Divider()
        
        ListItem(iconLeft: .icoEuro, title: "Titolo", subtitle: "Sottotitolo", amount: "3,000,000 €")
        Divider()
        
        ListItem(title: "Titolo", subtitle: "Sottotitolo", status: .success)
        Divider()
        
        ListItem(title: "Titolo", subtitle: "Sottotitolo", status: .pending)
        Divider()
        
        ListItem(title: "Titolo", subtitle: "Sottotitolo", status: .failed)
        Divider()
        
        ListItem(title: "Titolo", subtitle: "Sottotitolo", status: .toBeRefunded)
        Divider()
        
        ListItem(title: "Titolo", subtitle: "Sottotitolo", status: .refunded)
        Divider()
        
    }
    .padding(.horizontal, Spacings.medium.rawValue)
    
}
