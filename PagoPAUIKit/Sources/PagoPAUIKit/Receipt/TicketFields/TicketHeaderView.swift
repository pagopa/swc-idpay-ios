//
//  TicketHeaderView.swift
//
//
//  Created by Stefania Castiglioni on 10/01/24.
//

import SwiftUI

public struct TicketHeaderView: View {
    var image: Image
    var title: String
    
    public init(image: Image, title: String) {
        self.image = image
        self.title = title
    }
    
    public var body: some View {
        VStack {
            image
            
            Text(title)
                .font(.PAFont.receiptTitle)
        }
        .padding(.vertical, 18.0)
    }
}

#Preview {
    TicketHeaderView(image: Image(icon: .idPayLogo), title: "RICEVUTA DI PAGAMENTO")
}
