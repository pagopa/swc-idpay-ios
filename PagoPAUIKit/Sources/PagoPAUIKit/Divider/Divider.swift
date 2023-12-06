//
//  Divider.swift
//  
//
//  Created by Stefania Castiglioni on 29/11/23.
//

import SwiftUI

struct Divider: View {
    
    var orientation: Orientation = .horizontal
    var color: Color = .grey50
    
    enum Orientation {
        case horizontal, vertical
    }
    
    var body: some View {
        Rectangle()
            .frame(maxWidth: orientation == .horizontal ? .infinity : 1 , maxHeight: orientation == .horizontal ? 1 : .infinity)
        .background(color)
        .foregroundColor(.clear)
    }
}

struct Divider_Previews: PreviewProvider {
    static var previews: some View {
        
        ScrollView {
            VStack {
                Text("Prova")
                
                Divider(orientation: .horizontal)
                    .padding(Constants.mediumSpacing)
                
                Text("Horizontal divider")
            }
            .frame(maxWidth: .infinity)
            .padding(40)
            .background(Color.successLight)
            
            HStack(alignment: .center) {
                Text("Prova")
                    .frame(maxWidth: .infinity)

                
                Divider(orientation: .vertical, color: .infoGraphic)
                    .padding(Constants.mediumSpacing)
                
                Text("Vertical divider")
                    .frame(maxWidth: .infinity)
            }
            .frame(height: 120)
            .background(Color.infoLight)
        }
    }
}
