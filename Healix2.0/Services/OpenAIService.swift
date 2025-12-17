//
//  OpenAIService.swift
//  MedBot
//
//  Created by Arjun Krishnamurthy on 12/16/25.
//

import Foundation

// MARK: - OpenAI Service with Diagnosis Insights
// WARNING: This provides educational insights only, not medical diagnoses

class OpenAIService {
    static let shared = OpenAIService()
    private let diseaseDatabase = DiseaseDatabase.shared
    
    private init() {}
    
    struct AIResponse {
        let content: String
        let diagnosisInsight: DiagnosisInsight?
    }
    
    // Enhanced AI response with comprehensive disease identification
    func getDiagnosisResponse(for userMessage: String) async -> AIResponse {
        // Simulate API delay for AI processing
        try? await Task.sleep(nanoseconds: 1_500_000_000) // 1.5 seconds
        
        // Use AI-powered disease database analysis
        let matches = diseaseDatabase.analyzeSymptoms(userMessage)
        
        // Get top matches (up to 3)
        let topMatches = Array(matches.prefix(3))
        
        if let topMatch = topMatches.first, topMatch.confidence >= 40 {
            // High confidence match - provide detailed analysis
            return createDetailedResponse(for: topMatch, allMatches: topMatches, userMessage: userMessage)
        } else if !topMatches.isEmpty {
            // Lower confidence - provide general guidance
            return createGeneralResponse(matches: topMatches, userMessage: userMessage)
        }
        
        // No matches found - provide general guidance
        return createDefaultResponse(userMessage: userMessage)
    }
    
    private func createDetailedResponse(for match: DiseaseMatch, allMatches: [DiseaseMatch], userMessage: String) -> AIResponse {
        let disease = match.disease
        
        let insight = DiagnosisInsight(
            condition: disease.name,
            confidence: match.confidence,
            description: disease.description,
            recommendations: disease.recommendations,
            severity: disease.severity
        )
        
        var content = """
        **Potential Condition: \(disease.name)**
        Confidence Level: \(match.confidence)%
        Category: \(disease.category.rawValue)
        
        \(disease.description)
        
        **Matched Symptoms:**
        """
        
        for symptom in match.matchedSymptoms.prefix(5) {
            content += "\n• \(symptom.capitalized)"
        }
        
        content += "\n\n**Recommendations:**"
        for recommendation in disease.recommendations {
            content += "\n• \(recommendation)"
        }
        
        if disease.typicalDuration != "Chronic condition" {
            content += "\n\n**Typical Duration:** \(disease.typicalDuration)"
        }
        
        // Add other possible conditions if confidence is close
        if allMatches.count > 1 {
            let otherMatches = allMatches.filter { $0.confidence >= match.confidence - 20 && $0.disease.name != disease.name }
            if !otherMatches.isEmpty {
                content += "\n\n**Other Possible Conditions:**"
                for otherMatch in otherMatches.prefix(2) {
                    content += "\n• \(otherMatch.disease.name) (\(otherMatch.confidence)% confidence)"
                }
            }
        }
        
        content += "\n\n⚠️ **CRITICAL DISCLAIMER:** This is an educational insight based on symptom analysis, NOT a medical diagnosis. Always consult a licensed healthcare professional for proper evaluation and treatment."
        
        return AIResponse(content: content, diagnosisInsight: insight)
    }
    
    private func createGeneralResponse(matches: [DiseaseMatch], userMessage: String) -> AIResponse {
        var content = """
        Based on your symptoms, I've identified several possible conditions. Here are the most likely matches:
        
        """
        
        for (index, match) in matches.prefix(3).enumerated() {
            content += "\n\(index + 1). **\(match.disease.name)**"
            content += "\n   Confidence: \(match.confidence)%"
            content += "\n   Category: \(match.disease.category.rawValue)"
            content += "\n   Severity: \(match.disease.severity.rawValue)"
            content += "\n"
        }
        
        if let topMatch = matches.first {
            content += "\n**Most Likely:** \(topMatch.disease.name) (\(topMatch.confidence)% confidence)"
            content += "\n\n\(topMatch.disease.description)"
            content += "\n\n**Recommendations:**"
            for rec in topMatch.disease.recommendations.prefix(4) {
                content += "\n• \(rec)"
            }
        }
        
        content += "\n\n⚠️ **CRITICAL DISCLAIMER:** These are educational insights only, NOT medical diagnoses. Please consult a licensed healthcare professional for proper evaluation."
        
        let insight = matches.first.map { match in
            DiagnosisInsight(
                condition: match.disease.name,
                confidence: match.confidence,
                description: match.disease.description,
                recommendations: match.disease.recommendations,
                severity: match.disease.severity
            )
        }
        
        return AIResponse(content: content, diagnosisInsight: insight)
    }
    
    private func createDefaultResponse(userMessage: String) -> AIResponse {
        let lowercased = userMessage.lowercased()
        
        // Headache analysis
        if lowercased.contains("headache") {
            let insight = DiagnosisInsight(
                condition: "Tension Headache",
                confidence: 72,
                description: "Based on your symptoms, this may be a tension headache. Common causes include stress, poor posture, or eye strain.",
                recommendations: [
                    "Rest in a quiet, dark room",
                    "Apply a cold or warm compress",
                    "Stay hydrated",
                    "Consider over-the-counter pain relief (consult pharmacist)"
                ],
                severity: .mild
            )
            
            return AIResponse(
                content: """
                **Potential Condition: Tension Headache**
                Confidence Level: 72%
                
                Based on your description, this appears to be a tension headache. These are the most common type of headache and are often related to stress or muscle tension.
                
                **Recommendations:**
                • Rest in a quiet, dark room
                • Apply a cold or warm compress to your forehead
                • Stay hydrated throughout the day
                • Consider over-the-counter pain relief (consult a pharmacist first)
                
                ⚠️ **CRITICAL DISCLAIMER:** This is an educational insight based on limited information, NOT a medical diagnosis. If your headache is severe, persistent, or accompanied by other symptoms, consult a licensed healthcare professional immediately.
                """,
                diagnosisInsight: insight
            )
        }
        
        // Fever analysis
        if lowercased.contains("fever") || lowercased.contains("temperature") {
            let insight = DiagnosisInsight(
                condition: "Viral Infection (Possible)",
                confidence: 68,
                description: "Fever is typically the body's response to infection. The pattern and duration can help identify the cause.",
                recommendations: [
                    "Rest and stay hydrated",
                    "Monitor temperature regularly",
                    "Use fever-reducing medication if appropriate (consult pharmacist)",
                    "Seek medical attention if fever persists >3 days"
                ],
                severity: .moderate
            )
            
            return AIResponse(
                content: """
                **Potential Condition: Viral Infection**
                Confidence Level: 68%
                
                Fever is your body's natural defense mechanism against infection. The severity and duration can vary.
                
                **Recommendations:**
                • Rest and stay well-hydrated
                • Monitor your temperature regularly
                • Consider fever-reducing medication (consult a pharmacist)
                • Seek medical attention if fever persists beyond 3 days or exceeds 103°F
                
                ⚠️ **CRITICAL DISCLAIMER:** This is an educational insight, NOT a medical diagnosis. High or persistent fevers require professional medical evaluation. Always consult a licensed healthcare professional.
                """,
                diagnosisInsight: insight
            )
        }
        
        // Cough analysis
        if lowercased.contains("cough") {
            let insight = DiagnosisInsight(
                condition: "Upper Respiratory Infection",
                confidence: 65,
                description: "Coughs can result from various causes including allergies, infections, or irritants.",
                recommendations: [
                    "Stay hydrated to thin mucus",
                    "Use a humidifier",
                    "Avoid irritants like smoke",
                    "Consider honey (adults only) for soothing"
                ],
                severity: .mild
            )
            
            return AIResponse(
                content: """
                **Potential Condition: Upper Respiratory Infection**
                Confidence Level: 65%
                
                Your cough may be related to an upper respiratory infection, allergies, or environmental irritants.
                
                **Recommendations:**
                • Stay hydrated to help thin mucus
                • Use a humidifier to moisten the air
                • Avoid irritants like smoke or strong odors
                • Consider honey (adults only) for soothing relief
                
                ⚠️ **CRITICAL DISCLAIMER:** This is an educational insight, NOT a medical diagnosis. Persistent or severe coughs, especially with other symptoms, should be evaluated by a licensed healthcare professional.
                """,
                diagnosisInsight: insight
            )
        }
        
        // Chest pain (high severity)
        if lowercased.contains("chest pain") || lowercased.contains("chest discomfort") {
            let insight = DiagnosisInsight(
                condition: "Requires Immediate Evaluation",
                confidence: 85,
                description: "Chest pain can have serious causes and requires immediate medical attention.",
                recommendations: [
                    "Seek emergency medical care immediately",
                    "Do not delay if pain is severe",
                    "Call emergency services if needed"
                ],
                severity: .severe
            )
            
            return AIResponse(
                content: """
                **⚠️ URGENT: Requires Immediate Medical Evaluation**
                Confidence Level: 85%
                
                Chest pain can indicate serious conditions and should be evaluated immediately by a healthcare professional.
                
                **Immediate Actions:**
                • Seek emergency medical care right away
                • Do not delay if pain is severe or worsening
                • Call emergency services if needed
                
                ⚠️ **CRITICAL:** This is NOT a diagnosis. Chest pain requires immediate professional medical evaluation. Do not ignore or delay seeking care.
                """,
                diagnosisInsight: insight
            )
        }
        
        // No specific matches found - provide general guidance
        var content = """
        Thank you for sharing your health concern. I've analyzed your symptoms but couldn't identify a specific condition with high confidence.
        
        **General Recommendations:**
        • Document your symptoms in detail
        • Note when symptoms occur and any patterns
        • Track symptom severity over time
        • Monitor for any new or worsening symptoms
        """
        
        // Provide category-specific guidance if we can infer it
        if lowercased.contains("chest") || lowercased.contains("heart") || lowercased.contains("breathing") {
            content += "\n\n**Important:** If you're experiencing chest pain, difficulty breathing, or heart-related symptoms, seek immediate medical attention."
        } else if lowercased.contains("severe") || lowercased.contains("intense") || lowercased.contains("extreme") {
            content += "\n\n**Important:** If your symptoms are severe or worsening, please consult a healthcare professional promptly."
        }
        
        content += "\n\n⚠️ **CRITICAL DISCLAIMER:** This app provides educational insights only and is NOT a medical diagnosis. Always consult a licensed healthcare professional for proper evaluation and treatment of any health concerns."
        
        return AIResponse(content: content, diagnosisInsight: nil)
    }
    
    // Legacy method for backward compatibility
    func getEducationalResponse(for userMessage: String) async -> String {
        let response = await getDiagnosisResponse(for: userMessage)
        return response.content
    }
}

