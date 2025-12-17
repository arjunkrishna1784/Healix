//
//  Disease.swift
//  Healix
//
//  Created by Arjun Krishnamurthy on 12/16/25.
//

import Foundation

struct Disease: Identifiable, Codable {
    let id: UUID
    let name: String
    let category: DiseaseCategory
    let commonSymptoms: [String]
    let rareSymptoms: [String]
    let severity: SeverityLevel
    let description: String
    let typicalDuration: String
    let recommendations: [String]
    
    init(name: String, category: DiseaseCategory, commonSymptoms: [String], rareSymptoms: [String] = [], severity: SeverityLevel = .mild, description: String, typicalDuration: String, recommendations: [String]) {
        self.id = UUID()
        self.name = name
        self.category = category
        self.commonSymptoms = commonSymptoms
        self.rareSymptoms = rareSymptoms
        self.severity = severity
        self.description = description
        self.typicalDuration = typicalDuration
        self.recommendations = recommendations
    }
    
    // Calculate match score based on user symptoms
    func calculateMatchScore(userSymptoms: [String]) -> Double {
        let userSymptomsLower = userSymptoms.map { $0.lowercased() }
        let commonSymptomsLower = commonSymptoms.map { $0.lowercased() }
        let rareSymptomsLower = rareSymptoms.map { $0.lowercased() }
        
        var score: Double = 0
        var totalPossible: Double = 0
        
        // Common symptoms are weighted higher
        for symptom in commonSymptomsLower {
            totalPossible += 1.0
            if userSymptomsLower.contains(where: { $0.contains(symptom) || symptom.contains($0) }) {
                score += 1.0
            }
        }
        
        // Rare symptoms add bonus points
        for symptom in rareSymptomsLower {
            totalPossible += 0.5
            if userSymptomsLower.contains(where: { $0.contains(symptom) || symptom.contains($0) }) {
                score += 0.5
            }
        }
        
        // Also check for partial matches (keyword matching)
        for userSymptom in userSymptomsLower {
            for commonSymptom in commonSymptomsLower {
                if userSymptom.contains(commonSymptom) || commonSymptom.contains(userSymptom) {
                    score += 0.3
                    totalPossible += 0.3
                }
            }
        }
        
        guard totalPossible > 0 else { return 0 }
        return min(100, (score / totalPossible) * 100)
    }
}

enum DiseaseCategory: String, Codable {
    case respiratory = "Respiratory"
    case cardiovascular = "Cardiovascular"
    case neurological = "Neurological"
    case gastrointestinal = "Gastrointestinal"
    case musculoskeletal = "Musculoskeletal"
    case dermatological = "Dermatological"
    case infectious = "Infectious"
    case endocrine = "Endocrine"
    case mental = "Mental Health"
    case other = "Other"
}

