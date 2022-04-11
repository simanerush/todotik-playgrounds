//
//  Date+Minus.swift
//  Todotik
//
//  Created by Serafima Nerush on 2/20/22.
//

import Foundation

extension Date {
    
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
}
