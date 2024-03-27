//
//  HelpView.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 19/01/24.
//

import SwiftUI
import PagoPAUIKit

struct HelpView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            VStack {
                WebView(urlString: "https://www.pagopa.gov.it/it/assistenza/")
                    .ignoresSafeArea(edges: [.bottom])
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(icon: .arrowLeft)
                            .foregroundColor(.white)
                    }
                }

                ToolbarItem(placement: .principal) {
                        Text("Assistenza")
                            .font(.PAFont.h3)
                            .foregroundColor(.white)
                }
            })
            .background(Color.paPrimary)
        }
    }
}


struct HelpView_Previews: PreviewProvider {

    struct ContainerView: View {
        @State var isPresented: Bool = false

        var body: some View {
            VStack {
            
                Button {
                    isPresented.toggle()
                } label: {
                    Text("Show assistance")
                }
                .pagoPAButtonStyle(buttonType: .primary)
            }
            .padding(100)
            .fullScreenCover(isPresented: $isPresented) {
                HelpView()
            }
        }
    }

    static var previews: some View {
        ContainerView()
    }

}
