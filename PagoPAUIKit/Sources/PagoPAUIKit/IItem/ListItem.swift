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
    var statusType: OperationStatus?
    var statusDescription: String?
    var iconButtonRight: Image.PAIcon?
    var amountText: String?
    var actionButtonRight: (() -> Void)?
    
    public init(iconLeft: Image.PAIcon? = nil,
                title: String, subtitle: String,
                statusType: OperationStatus? = nil,
                statusDescription: String? = nil,
                icon: Image.PAIcon? = nil,
                amount: String? = nil,
                actionButtonRight: (() -> Void)? = nil ) {
        self.iconLeft = iconLeft
        self.titleText = title
        self.subTitleText = subtitle
        self.statusType = statusType
        self.statusDescription = statusDescription
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
                            .resizable()
                            .frame(width: Constants.listItemIconSize, height: Constants.listItemIconSize)
                            .padding(.trailing, Constants.smallSpacing)
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
                            .resizable()
                            .frame(width: Constants.listItemIconSize, height: Constants.listItemIconSize)
                    }
                    
                } else if let amount = amountText{
                    Text(amount)
                        .font(.PAFont.h6)
                        .foregroundColor(Color.paBlack)
                    
                } else if let statusType = statusType, let statusDescription = statusDescription {
                    OperationStatusLabel(statusType: statusType, statusDescription: statusDescription)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
        .padding(.vertical, Constants.mediumSpacing/2.0)
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
        
        ListItem(title: "Titolo", subtitle: "Sottotitolo", statusType: .success)
        Divider()
        
        ListItem(title: "Titolo", subtitle: "Sottotitolo", statusType: .pending)
        Divider()
        
        ListItem(title: "Titolo", subtitle: "Sottotitolo", statusType: .failed)
        Divider()
        
        ListItem(title: "Titolo", subtitle: "Sottotitolo", statusType: .toBeRefunded)
        Divider()
        
        ListItem(title: "Titolo", subtitle: "Sottotitolo", statusType: .refunded)
        Divider()
        
    }
    .padding(.horizontal, Constants.mediumSpacing)
    
}
