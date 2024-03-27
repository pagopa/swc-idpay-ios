//
//  Router.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 07/02/24.
//

import SwiftUI

@MainActor
class Router: ObservableObject {
    
    @Published var navigationPath = [Route]()
    
    func pushTo(_ route: Route) {
        navigationPath.append(route)
    }
    
    func pop() {
        _ = navigationPath.removeLast()
    }
    
    func popToRoot() {
        navigationPath.removeAll()
    }
        
    func pop(to route: Route) {
        guard let routeFound = navigationPath.firstIndex(where: { $0 == route }) else {
            return
        }

        let itemsToPop = (routeFound..<navigationPath.endIndex).count - 1
        navigationPath.removeLast(itemsToPop)
    }
    
    func pop(last: Int){
        guard navigationPath.count > last else { return }
        navigationPath.removeLast(last)
    }

    func replaceStack(with stack: [Route]) {
        navigationPath = stack
    }

}
