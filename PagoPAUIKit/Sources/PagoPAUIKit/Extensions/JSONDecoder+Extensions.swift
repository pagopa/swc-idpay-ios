//
//  JSONDecoder+Extensions.swift
//
//
//  Created by Stefania Castiglioni on 12/01/24.
//

import Foundation

extension JSONDecoder {
    
    public func decodeFromLocalJSON<T: Codable>(name: String) -> T? {
        guard let path = Bundle.main.path(forResource: name, ofType: "json") else {
            fatalError("File with name \(name).json does not exists")
        }

        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: [])
            return try self.decode(T.self, from: data)
        } catch {
            print("Error decoding file \(name).json:\(error.localizedDescription)")
        }
        
        return nil
    }
}
