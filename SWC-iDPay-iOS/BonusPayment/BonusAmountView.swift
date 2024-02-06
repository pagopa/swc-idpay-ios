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
    @State var isReadingCIE: Bool = false
    
    private var reader = CIEReader(readCardMessage: "Appoggia la CIE sul dispositivo, in alto", confirmCardReadMessage: "Lettura completata")
    
    var body: some View {
        ZStack {
            backgroundView
            
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
                
                if isReadingCIE {
                    Spacer()
                    retryCIEScanView
                    Spacer()

                } else {
                    paymentView
                }
                
            }
            .padding(Constants.mediumSpacing)
        }
    }
    
    @ViewBuilder
    private var backgroundView: some View {
        if isReadingCIE {
            Color
                .grey50
                .ignoresSafeArea()
        } else {
            Color
                .white
                .ignoresSafeArea()
        }
    }
    
    @ViewBuilder
    private var paymentView: some View {
        Spacer()
        NumberPad(.numeric, string: $amountText)
        Spacer()
        CustomLoadingButton(
            buttonType: .primary,
            isLoading: $isLoading) {
                isReadingCIE = true

                // TODO: call backend first, hide paymentView and show retry view
                startCIEScan()
                
            } label: {
                Text("Conferma")
            }
            .disabled(amountText == "0,00")
    }
    
    @ViewBuilder
    private var retryCIEScanView: some View {
            
            
            VStack(spacing: Constants.smallSpacing) {
                
                Text("IDENTIFICAZIONE CON CIE")
                    .foregroundColor(.paPrimary)
                    .font(.PAFont.caption)
                
                Text("Appoggia la CIE sul dispositivo, in alto")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.paBlack)
                    .font(.PAFont.h4)
                    .padding(.bottom, Constants.xsmallSpacing)
                
                Spacer()
                Image("cie", bundle: nil)
                Spacer()
                
                Button("Riprova") {
                    startCIEScan()
                }
                .pagoPAButtonStyle(buttonType: .primary)
                .padding(.vertical, Constants.xsmallSpacing)
            }
            .padding(Constants.mediumSpacing)
            .background(
                RoundedRectangle(cornerRadius: 10.0)
                    .fill(Color.white)
            )
    }
    
    private func startCIEScan() {
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
                    // TODO: Show error NFC not available
                    print("NFC not available")
                default:
                    break
                }
            }
        }
        
    }
}

#Preview {
    BonusAmountView()
}
