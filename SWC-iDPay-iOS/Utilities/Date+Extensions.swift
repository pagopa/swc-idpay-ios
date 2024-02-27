//
//  Date+Extensions.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 13/02/24.
//

import Foundation

extension Date {
    
    func toUTCString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return dateFormatter.string(from: self)
    }
    
    public var formattedDateTime: String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM yyyy, HH:mm"
        return dateFormatter.string(from: self)
    }

}
