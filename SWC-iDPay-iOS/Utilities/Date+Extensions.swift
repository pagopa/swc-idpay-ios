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

#if DEBUG
extension Date {
    
    static func randomUTCDateString() -> String {
        Date.randomBetween(start: Date(), end: getLastWeekStartDate()).toUTCString()
    }
    
    static func randomUTCDate() -> Date {
        Date.randomBetween(start: Date(), end: getLastWeekStartDate())
    }
    
    private var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }

    private static func getLastWeekStartDate() -> Date {
        let startDate = Date().startOfDay
        return Calendar.current.date(byAdding: .day, value: -6, to: startDate)!
    }

    private static func randomBetween(start: Date, end: Date) -> Date {
        var date1 = start
        var date2 = end
        if date2 < date1 {
            let temp = date1
            date1 = date2
            date2 = temp
        }
        let span = TimeInterval.random(in: date1.timeIntervalSinceNow...date2.timeIntervalSinceNow)
        return Date(timeIntervalSinceNow: span)
    }

}
#endif
