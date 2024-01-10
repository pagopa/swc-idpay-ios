//
//  View+PdfRender.swift
//
//
//  Created by Stefania Castiglioni on 10/01/24.
//

import UIKit
import SwiftUI

extension View {
        
    @MainActor
    public func renderToPdf(filename: String, location: URL) -> URL {
    
        let renderer = ImageRenderer(content: self)
        let url = location.appending(path: filename)
        
        renderer.render { size, context in
            var box = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            
            guard let pdf = CGContext(url as CFURL, mediaBox: &box, nil) else {
                return
            }
            
            pdf.beginPDFPage(nil)
            
            context(pdf)
            
            pdf.endPDFPage()
            pdf.closePDF()
        }
        
        return url
    }
}
