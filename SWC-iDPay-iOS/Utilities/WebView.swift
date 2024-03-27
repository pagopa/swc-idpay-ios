//
//  WebView.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 19/01/24.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
 
    var urlString: String
    let webView: WKWebView
    
    init(urlString: String) {
        self.urlString = urlString
        webView = WKWebView(frame: .zero)
        webView.allowsLinkPreview = true
    }
    
    func makeUIView(context: Context) -> WKWebView {
        return webView
    }
    func updateUIView(_ uiView: WKWebView, context: Context) {
        webView.load(URLRequest(url: URL(string: urlString)!))
    }
}

#Preview {
    WebView(urlString: "https://www.pagopa.gov.it/it/assistenza/")
}
