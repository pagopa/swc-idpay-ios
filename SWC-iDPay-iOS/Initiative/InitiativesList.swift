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
    @StateObject var viewModel: InitiativesViewModel = InitiativesViewModel()
    
    var body: some View {
         
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading) {
                    Text("Scegli l'iniziativa")
                        .font(.PAFont.h3)
                        .foregroundColor(.paBlack)
                        .padding(.vertical, Constants.mediumSpacing)
                    
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
        }
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
    InitiativesList()
        .environmentObject(Router())
}
