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
    @State private var showHelp: Bool = false
    
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
                            Button(action: {
                                router.pushTo(
                                    .bonusAmount(
                                        viewModel: BonusAmountViewModel(
                                            networkClient: viewModel.networkClient,
                                            initiative: initiative)
                                    ))
                            }, label: {
                                VStack {
                                    InitiativeRow(initiative: initiative)
                                    
                                    if initiative != viewModel.initiatives.last {
                                        Divider()
                                    }
                                }
                            })
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
        .showLoadingView(message: $viewModel.loadingStateMessage, isLoading: $viewModel.isLoading)
        .fullScreenCover(isPresented: $showHelp) {
            HelpView()
                .ignoresSafeArea()
        }
        .fullScreenCover(isPresented: $viewModel.showError) {
            getErrorView()
        }
    }
    
    private var emptyStateView: some View {
        VStack {
            Spacer()
            
            Text("Nessuna iniziativa trovata")
                .font(.PAFont.h3)
            Text("Al momento non sono disponibili iniziative")
                .font(.PAFont.body)
            
            Button {
                showHelp.toggle()
            } label: {
                Text("Vai all'assistenza")
            }
            .pagoPAButtonStyle(buttonType: .primaryBordered, fullwidth: false)
            .padding(.vertical, Constants.xlargeSpacing)
            
            Spacer()
        }
        .foregroundColor(.paBlack)
        .padding(Constants.mediumSpacing)
    }
    
    fileprivate func getErrorView() -> ThankyouPage {
        return ThankyouPage(
            result: ResultModel(
                title: "Non è stato possibile recuperare la lista delle iniziative",
                subtitle: "Riprova tra qualche minuto",
                themeType: .error,
                buttons: [
                    ButtonModel(
                        type: .primary,
                        themeType: .error,
                        title: "Torna alla home",
                        action: {
                            router.pop()
                        }
                    )
                ]
            )
        )
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
