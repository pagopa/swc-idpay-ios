//
//  TransactionsHistoryList.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 07/02/24.
//

import SwiftUI

struct TransactionsHistoryList: View {
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            Text("Transactions History")
                .font(.PAFont.h1Hero)
        }
    }
}

#Preview {
    TransactionsHistoryList()
}
