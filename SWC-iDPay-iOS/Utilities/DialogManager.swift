//
//  DialogManager.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 12/03/24.
//

import Foundation
import UIKit
import SwiftUI
import PagoPAUIKit

class DialogManager {
    
    public static let shared = DialogManager()

    private var shownVC: UIViewController?

    private init() {}

    public func present<Content>(content: Content) where Content: View {
        DispatchQueue.main.async {
            if let rootVC = UIViewController.topViewController, let rootView = rootVC.view {
                let popupVC = UIHostingController(rootView: content)
                popupVC.view.frame = rootView.bounds
                popupVC.view.backgroundColor = .clear
                popupVC.view.isOpaque = false
                popupVC.modalPresentationStyle = .overCurrentContext
                popupVC.modalTransitionStyle = .crossDissolve
                rootVC.present(popupVC, animated: true)
                
                self.shownVC = popupVC
            }
        }
    }
    
    /// Dismisses the shown popup, if any.
    public func dismiss(completion: @escaping () -> Void = {}) {
        guard let shownVC else {
            completion()
            return
        }

        shownVC.dismiss(animated: true, completion: { [weak self] in
            self?.shownVC = nil
            completion()
        })
    }

    public func showDialog(dialogModel: ResultModel) {
        
        let alert = DialogView(dialogModel: dialogModel, isPresenting: Binding<Bool> (
            get: { return true },
            set: {_ in }
        ))
        
        if shownVC != nil { dismiss {
            self.present(content: alert)

        } } else {
            present(content: alert)
        }

    }
}

extension UIViewController {

    /// Retrieve the root view controller of the app.
    public static var root: UIViewController? {
        UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.rootViewController
    }
    
    public static var topViewController: UIViewController? {
        if let nav = root as? UINavigationController {
            return nav.visibleViewController
        } else if let tab = root as? UITabBarController {
            return tab.selectedViewController
        } else if let presented = root?.presentedViewController {
            return presented
        } else {
            return root
        }
    }

}
