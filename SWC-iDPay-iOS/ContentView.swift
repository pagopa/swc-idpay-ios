//
//  ContentView.swift
//  SWC-iDPay-iOS
//
//  Created by Pier Domenico Bonamassa on 29/11/23.
//

import SwiftUI
import PagoPAUIKit

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
            Text("Hello, world!")
                .font(.PAFont.h1)
        }
        .foregroundStyle(Color.paPrimaryDark)
        .padding()
    }
}

#Preview {
    ContentView()
}
