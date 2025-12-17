//
//  DailyMetric.swift
//  MedBot
//
//  Created by Arjun Krishnamurthy on 12/16/25.
//

import Foundation

struct DailyMetric: Identifiable {
    let id: UUID
    let date: Date
    let value: Double
    
    init(date: Date, value: Double) {
        self.id = UUID()
        self.date = date
        self.value = value
    }
    
    var dayName: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: date)
    }
}

