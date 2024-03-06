//
//  URLSessionProtocol.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 12/02/24.
//

import Foundation

protocol URLSessionProtocol {
    func data(from url: URL, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse)
}

extension URLSessionProtocol {
    // If we want to avoid having to always pass 'delegate: nil'
    // at call sites where we're not interested in using a delegate,
    // we also have to add the following convenience API (which
    // URLSession itself provides when using it directly):
    func data(from url: URL) async throws -> (Data, URLResponse) {
        try await data(from: url, delegate: nil)
    }
}

extension URLSession: URLSessionProtocol {}
