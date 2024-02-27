//
//  String+Extensions.swift
//
//
//  Created by Stefania Castiglioni on 12/01/24.
//

import Foundation

extension String {
    
    public var toUTCDate: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return dateFormatter.date(from: self)
    }
    
}
