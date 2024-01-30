//
//  BonusAmountView.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 18/01/24.
//
import SwiftUI
import PagoPAUIKit
import CIEScanner

struct BonusAmountView : View {
    @State var isLoading: Bool = false
    @State var amountText: String = "0,00"
    
    private var reader = CIEReader()

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
        .padding(Constants.mediumSpacing)
    }
    
    @ViewBuilder
    private var paymentView: some View {
        Spacer()
        NumberPad(.numeric, string: $amountText)
        Spacer()
        CustomLoadingButton(
            buttonType: .primary,
            isLoading: $isLoading) {
                Task {
                    do {
                        guard let nisAuthenticated = try await reader.scan() else {
                            print("No NISAuthenticated found")
                            return
                        }
                        print(nisAuthenticated.toString())
                    } catch {
                        guard let cieError = error as? CIEReaderError else { return }
                        switch cieError {
                        case .scanNotSupported:
                            print("NFC not available")
                        default:
                            break
                        }
                    }
                }

            } label: {
                Text("Conferma")
            }
            .disabled(amountText == "0,00")
    }
}

#Preview {
    BonusAmountView()
}
