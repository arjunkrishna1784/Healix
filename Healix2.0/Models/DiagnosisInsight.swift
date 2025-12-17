//
//  DiagnosisInsight.swift
//  MedBot
//
//  Created by Arjun Krishnamurthy on 12/16/25.
//

import Foundation

struct DiagnosisInsight: Identifiable, Codable {
    let id: UUID
    let condition: String
    let confidence: Int // 0-100
    let description: String
    let recommendations: [String]
    let severity: SeverityLevel
    
    init(condition: String, confidence: Int, description: String, recommendations: [String], severity: SeverityLevel = .mild) {
        self.id = UUID()
        self.condition = condition
        self.confidence = max(0, min(100, confidence))
        self.description = description
        self.recommendations = recommendations
        self.severity = severity
    }
}

enum SeverityLevel: String, Codable {
    case mild = "Mild"
    case moderate = "Moderate"
    case severe = "Severe"
    
    var color: String {
        switch self {
        case .mild: return "green"
        case .moderate: return "orange"
        case .severe: return "red"
        }
    }
}

