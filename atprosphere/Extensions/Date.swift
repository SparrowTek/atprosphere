//
//  Date.swift
//  atprosphere
//
//  Created by Thomas Rademaker on 10/31/23.
//

import Foundation

extension Date {
    private var createdAtRelativeFormatter: RelativeDateTimeFormatter {
        let dateFormatter = RelativeDateTimeFormatter()
        dateFormatter.unitsStyle = .abbreviated
        return dateFormatter
    }
    
//    private var createdAtShortDateFormatted: DateFormatter {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateStyle = .medium
//        return dateFormatter
//    }
    
    private var createdAt: String {
        let calendar = Calendar.current
        let now = Date()
        guard let days = calendar.dateComponents([.day], from: self, to: now).day else { return "" }
        
        return "\(days)d"
    }
    
    var formatted: String {
        let calendar = Calendar(identifier: .gregorian)
        
        if calendar.numberOfDaysBetween(self, and: Date()) ?? 0 > 1 {
            return createdAt
        } else {
            return createdAtRelativeFormatter.localizedString(for: self, relativeTo: Date())
        }
    }
}
