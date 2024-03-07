//
//  URLRequest+Encoding.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 09/02/24.
//

import Foundation

typealias Parameters = [String: Any]
typealias Headers    = [String: String]

extension URLRequest {
    
    static func buildRequest(baseUrl: URL, endpoint: Endpoint) -> URLRequest {
        
        var encodedURLRequest = URLRequest(url: baseUrl.appendingPathComponent(endpoint.path))
        encodedURLRequest.httpMethod = endpoint.method.rawValue
        encodedURLRequest.addHeaders(endpoint.headers)
        
        if let url = encodedURLRequest.url, !endpoint.body.isEmpty {
            let parameters = endpoint.body

            // Adding parameters
            switch endpoint.encoding {
            case .urlEncoding:
                if let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false),
                    !parameters.isEmpty {
                    var newUrlComponents = urlComponents
                    let queryItems: [URLQueryItem] = parameters.compactMap {
                        var value = $0.value
                        if $0.value is String {
                            value = ($0.value as! String).addingPercentEncoding(
                                withAllowedCharacters: .urlQueryAllowed
                            ) ?? $0.value
                        }
                        return URLQueryItem(name: $0.key, value: "\(value)")
                    }
                    newUrlComponents.queryItems = queryItems
                    encodedURLRequest.url = newUrlComponents.url
                }
            case .formUrlEncoded:
                var array: [String] = []

                array.append(contentsOf: parameters.compactMap {
                    let key = $0.key
                    var value = $0.value
                    if $0.value is String {
                        value = ($0.value as! String).addingPercentEncoding(
                            withAllowedCharacters: .afURLQueryAllowed
                        ) ?? $0.value
                    }
                    return "\(key)=\(value)"
                })

                let encodedParameters = array.joined(separator: "&")
                encodedURLRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                encodedURLRequest.httpBody = encodedParameters.data(using: .utf8)
            case .jsonEncoding:
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
                    encodedURLRequest.httpBody = jsonData
                    encodedURLRequest.httpMethod = endpoint.method.rawValue
                                                    
                } catch let error {
                    print("JSONENcoder error:\(error.localizedDescription)")
                }
            }

        }
        
        return encodedURLRequest
    }
    
    static func buildRequest<T: Codable>(baseUrl: URL, endpoint: Endpoint, parameters: Parameters? = nil, object: T? = nil) -> URLRequest {
        
        var encodedURLRequest = URLRequest(url: baseUrl.appendingPathComponent(endpoint.path))
        encodedURLRequest.httpMethod = endpoint.method.rawValue
        encodedURLRequest.addHeaders(endpoint.headers)
        
        if let parameters = parameters, let url = encodedURLRequest.url {
            // Adding parameters
            switch endpoint.encoding {
            case .urlEncoding:
                if let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false),
                    !parameters.isEmpty {
                    var newUrlComponents = urlComponents
                    let queryItems: [URLQueryItem] = parameters.compactMap {
                        var value = $0.value
                        if $0.value is String {
                            value = ($0.value as! String).addingPercentEncoding(
                                withAllowedCharacters: .urlQueryAllowed
                            ) ?? $0.value
                        }
                        return URLQueryItem(name: $0.key, value: "\(value)")
                    }
                    newUrlComponents.queryItems = queryItems
                    encodedURLRequest.url = newUrlComponents.url
                }
            case .formUrlEncoded:
                var array: [String] = []
                array.append(contentsOf: parameters.compactMap {
                    let key = $0.key
                    var value = $0.value
                    if $0.value is String {
                        value = ($0.value as! String).addingPercentEncoding(
                            withAllowedCharacters: .afURLQueryAllowed
                        ) ?? $0.value
                    }
                    return "\(key)=\(value)"
                })

                let encodedParameters = array.joined(separator: "&")
                encodedURLRequest.httpBody = encodedParameters.data(using: .utf8)
            case .jsonEncoding:
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
                    encodedURLRequest.httpBody = jsonData
                    encodedURLRequest.httpMethod = endpoint.method.rawValue
                                                    
                } catch let error {
                    print("JSONENcoder error:\(error.localizedDescription)")
                }
            }

        }

        if let object = object {
            do {
                let jsonData = try JSONEncoder().encode(object)
                encodedURLRequest.httpBody = jsonData
            } catch {
                print("JSONENcoder error:\(error.localizedDescription)")
            }
        }
        return encodedURLRequest
    }
}

extension URLRequest {
    
    mutating func addHeaders(_ headers: HTTPHeaders) {
        for (key, value) in headers {
            self.addValue(value, forHTTPHeaderField: key)
        }
    }

}

extension CharacterSet {
    // Creates a CharacterSet from RFC 3986 allowed characters.
    //
    // RFC 3986 states that the following characters are "reserved" characters.
    //
    // - General Delimiters: ":", "#", "[", "]", "@", "?", "/"
    // - Sub-Delimiters: "!", "$", "&", "'", "(", ")", "*", "+", ",", ";", "="
    //
    // In RFC 3986 - Section 3.4, it states that the "?" and "/" characters should not be escaped to allow
    // query strings to include a URL. Therefore, all "reserved" characters with the exception of "?" and "/"
    // should be percent-escaped in the query string.

    static let afURLQueryAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        let encodableDelimiters = CharacterSet(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")

        return CharacterSet.urlQueryAllowed.subtracting(encodableDelimiters)
    }()
}
