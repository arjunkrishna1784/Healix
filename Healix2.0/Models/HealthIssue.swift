//
//  HealthIssue.swift
//  Healix
//
//  Created by Arjun Krishnamurthy on 12/16/25.
//

import Foundation

struct HealthIssue: Identifiable, Codable {
    let id: UUID
    let userMessage: String
    let aiResponse: String
    let diagnosisInsight: DiagnosisInsight?
    let date: Date
    
    init(userMessage: String, aiResponse: String, diagnosisInsight: DiagnosisInsight? = nil) {
        self.id = UUID()
        self.userMessage = userMessage
        self.aiResponse = aiResponse
        self.diagnosisInsight = diagnosisInsight
        self.date = Date()
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d, yyyy"
        return formatter.string(from: date)
    }
    
    var shortDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: date)
    }
}

class HealthIssueHistory: ObservableObject {
    static let shared = HealthIssueHistory()
    
    @Published var issues: [HealthIssue] = []
    
    private let historyKey = "healthIssueHistory"
    
    private init() {
        loadHistory()
    }
    
    func addIssue(_ issue: HealthIssue) {
        issues.insert(issue, at: 0) // Add to beginning
        saveHistory()
    }
    
    private func loadHistory() {
        if let data = UserDefaults.standard.data(forKey: historyKey),
           let decoded = try? JSONDecoder().decode([HealthIssue].self, from: data) {
            issues = decoded
        }
    }
    
    private func saveHistory() {
        if let encoded = try? JSONEncoder().encode(issues) {
            UserDefaults.standard.set(encoded, forKey: historyKey)
        }
    }
}

