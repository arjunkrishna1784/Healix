//
//  ChatMessage.swift
//  MedBot
//
//  Created by Arjun Krishnamurthy on 12/16/25.
//

import Foundation

struct ChatMessage: Identifiable, Codable {
    let id: UUID
    let content: String
    let isUser: Bool
    let timestamp: Date
    var diagnosisInsight: DiagnosisInsight?
    
    init(content: String, isUser: Bool, diagnosisInsight: DiagnosisInsight? = nil) {
        self.id = UUID()
        self.content = content
        self.isUser = isUser
        self.timestamp = Date()
        self.diagnosisInsight = diagnosisInsight
    }
}

