//
//  BonusAmountView.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 18/01/24.
//
import SwiftUI
import PagoPAUIKit

struct BonusAmountView : View {
    @State var isLoading: Bool = false
    @State var amountText: String = "0,00"
    
    var body: some View {
        VStack {
            Text("IMPORTO DEL BENE")
                .font(.PAFont.caption)
                .foregroundColor(.paBlack)
                .padding(.top, Constants.mediumSpacing)
            
            Group {
                Text(amountText)
                    .font(.PAFont.h1Hero)
                +
                Text(" €")
                    .font(.PAFont.caption)
            }
            .padding(Constants.smallSpacing)

            paymentView
            
        }
        .padding(24.0)
    }
    
    @ViewBuilder
    private var paymentView: some View {
        Spacer()
        NumberPad(.numeric, string: $amountText)
        Spacer()
        CustomLoadingButton(
            buttonType: .primary,
            isLoading: $isLoading) {
                
            } label: {
                Text("Conferma")
            }
    }
}

#Preview {
    BonusAmountView()
}
