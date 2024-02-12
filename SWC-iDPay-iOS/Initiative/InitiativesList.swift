//
//  InitiativesList.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 07/02/24.
//

import SwiftUI
import PagoPAUIKit

struct InitiativesList: View {
    
    @EnvironmentObject var router: Router
    @ObservedObject var viewModel: InitiativesViewModel

    init(viewModel: InitiativesViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            if viewModel.initiatives.count > 0 {
                
                ScrollView {
                    VStack {
                        Text("Scegli l'iniziativa")
                            .font(.PAFont.h3)
                            .foregroundColor(.paBlack)
                            .padding(.vertical, Constants.mediumSpacing)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        ForEach(viewModel.initiatives) { initiative in
                            
                            VStack {
                                InitiativeRow(initiative: initiative)
                                
                                if initiative != viewModel.initiatives.last {
                                    Divider()
                                }
                            }
                            .onTapGesture {
                                router.pushTo(.bonusAmount)
                            }
                        }
                        
                    }
                    .padding(.horizontal, Constants.mediumSpacing)
                }
            } else {
                emptyStateView
            }
        }
        .onAppear {
            viewModel.loadInitiatives()
        }
        .showLoadingView(message: "Aspetta qualche istante..", isLoading: $viewModel.isLoading)
    }
    
    private var emptyStateView: some View {
        VStack {
            Spacer()
            
            Text("Non ci sono iniziative attive")
                .font(.PAFont.h3)
            Text("Al momento non sono disponibili iniziative")
                .font(.PAFont.body)
            
            Button {
                viewModel.loadInitiatives()
            } label: {
                Text("Riprova")
            }
            .pagoPAButtonStyle(buttonType: .primaryBordered, fullwidth: false)
            .padding(.vertical, Constants.xlargeSpacing)
            
            Spacer()
        }
        .foregroundColor(.paBlack)
        .padding(Constants.mediumSpacing)
    }
    
}

fileprivate struct InitiativeRow: View {
    
    var initiative: Initiative
    
    var body: some View {
        HStack {
            Text(initiative.name)
                .font(.PAFont.h6)
                .foregroundColor(.paBlack)
            Spacer()
            Image(icon: .chevron)
        }
        .frame(minHeight: Constants.listRowHeight)
    }
}

#Preview {
    InitiativesList(viewModel: InitiativesViewModel(networkClient: NetworkClient(environment: .staging)))
        .environmentObject(Router())
}
