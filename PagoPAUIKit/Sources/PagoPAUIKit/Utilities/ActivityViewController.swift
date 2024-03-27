//
//  ActivityViewController.swift
//
//
//  Created by Stefania Castiglioni on 10/01/24.
//

import Foundation
import SwiftUI

public struct ActivityViewController: UIViewControllerRepresentable {

    @Binding var pdfURL: URL?
    @Binding var hasDone: Bool

    var applicationActivities: [UIActivity]? = nil

    public init(fileURL: Binding<URL?>, hasDoneAction: Binding<Bool>, applicationActivities: [UIActivity]? = nil){
        _pdfURL = fileURL
        _hasDone = hasDoneAction
        self.applicationActivities = applicationActivities
    }
        
    public func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityViewController>) -> UIActivityViewController {
        
        var activityItems: [Any] = []
        if let pdfURL {
            activityItems = [pdfURL]
        }
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        controller.completionWithItemsHandler = { (activityType, completed, returnedItems, error) in
            self.hasDone = true
        }
        return controller
    }

    public func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityViewController>) {}

}
