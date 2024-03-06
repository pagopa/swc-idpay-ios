//
//  NumberPadRow.swift
//
//
//  Created by Stefania Castiglioni on 18/01/24.
//

import SwiftUI

struct NumberPadRow: View {
    var numbers: [String]
    
    init(_ numbers: [String]) {
        self.numbers = numbers
    }
    
    var body: some View {
        HStack {
            ForEach(numbers, id: \.self) { k in
                KeyPadButton(k)
            }
        }
        .frame(height: Constants.padButtonSize)
    }
}
