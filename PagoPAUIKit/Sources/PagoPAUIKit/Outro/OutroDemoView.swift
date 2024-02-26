//
//  OutroDemoView.swift
//  
//
//  Created by Pier Domenico Bonamassa on 15/12/23.
//

import SwiftUI

public struct OutroDemoView: View {
    public init() {}
    public var body: some View {
        Outro(model: OutroModel(title: "Operazione conclusa",
                                subtitle: "Puoi riemettere la ricevuta in un momento successivo dalla sezione ‘Storico operazioni’.",
                                actionTitle: "Paga l'importo residuo", action: {
                                print("Paga l'importo residuo")
                            })
        )
    }
}

#Preview {
    OutroDemoView()
}
