//
//  ItemsDemoView.swift
//
//
//  Created by Pier Domenico Bonamassa on 12/12/23.
//

import SwiftUI

public struct ItemsDemoView: View {
    
    public init() {}
    
    public var body: some View {
        ScrollView{
            
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
            
            ListItem(title: "Titolo", subtitle: "Sottotitolo", status: .failed)
            Divider()
            
            ListItem(title: "Titolo", subtitle: "Sottotitolo", status: .pending)
            Divider()
            
            ListItem(title: "Titolo", subtitle: "Sottotitolo", status: .refunded)
            Divider()
            
            ListItem(title: "Titolo", subtitle: "Sottotitolo", status: .success)
            Divider()
            
            ListItem(title: "Titolo", subtitle: "Sottotitolo", status: .toBeRefunded)
            Divider()
            
            ListItemHistory(iconLeft: .checkmark ,titleText: "Titolo", subTitleText: "Sottotitolo", amountText: "3,000,000 €")
            Divider()
            
            ListItemHistory(iconLeft: .warning ,titleText: "Titolo", subTitleText: "Sottotitolo", amountText: "3,000,000 €")
            Divider()
            
            ListItemHistory(iconLeft: .pending ,titleText: "Titolo", subTitleText: "Sottotitolo", amountText: "3,000,000 €")
            Divider()
            
            ListItemHistory(iconLeft: .refunded ,titleText: "Titolo", subTitleText: "Sottotitolo", amountText: "3,000,000 €")
            Divider()
            
            ListItemHistory(iconLeft: .toBeRefunded ,titleText: "Titolo", subTitleText: "Sottotitolo", amountText: "3,000,000 €")
            Divider()
        }
        .scrollIndicators(.hidden)
        .padding(.horizontal, Spacings.medium.rawValue)
    }
}

#Preview {
    ItemsDemoView()
}
