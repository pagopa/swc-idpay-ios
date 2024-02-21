//
//  HomeView.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 06/02/24.
//

import SwiftUI
import PagoPAUIKit

struct HomeView: View {
    
    @EnvironmentObject var router: Router
    @ObservedObject var viewModel: HomeViewModel

    var body: some View {
        IntroView(
            title: "Accetta un bonus ID Pay",
            subtitle: "Inserisci i dettagli del pagamento e permetti ai tuoi clienti di utilizzare un bonus ID Pay.",
            actionTitle: "Accetta bonus ID Pay") {
                router.pushTo(.initiatives(viewModel: InitiativesViewModel(networkClient: viewModel.networkClient)))
            }
    }
}

#Preview {
    HomeView(viewModel: HomeViewModel(networkClient: NetworkClient(environment: .staging)))
}
