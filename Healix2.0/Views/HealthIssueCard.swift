//
//  HealthIssueCard.swift
//  Healix
//
//  Created by Arjun Krishnamurthy on 12/16/25.
//

import SwiftUI

struct HealthIssueCard: View {
    let issue: HealthIssue
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Date Header
            HStack {
                Image(systemName: "calendar")
                    .foregroundColor(.yellow)
                Text(issue.formattedDate)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Spacer()
            }
            
            Divider()
            
            // User Message
            VStack(alignment: .leading, spacing: 4) {
                Text("Your Concern:")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(issue.userMessage)
                    .font(.body)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            
            // AI Response Preview
            VStack(alignment: .leading, spacing: 4) {
                Text("AI Response:")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(issue.aiResponse)
                    .font(.body)
                    .lineLimit(3)
            }
            .padding()
            .background(Color.yellow.opacity(0.1))
            .cornerRadius(12)
            
            // Diagnosis Insight (if available)
            if let insight = issue.diagnosisInsight {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(insight.condition)
                            .font(.headline)
                            .fontWeight(.bold)
                        Text("\(insight.confidence)% confidence")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    Text(insight.severity.rawValue)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(severityColor.opacity(0.2))
                        .foregroundColor(severityColor)
                        .cornerRadius(8)
                }
                .padding()
                .background(severityColor.opacity(0.05))
                .cornerRadius(12)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 2)
    }
    
    private var severityColor: Color {
        guard let insight = issue.diagnosisInsight else { return .gray }
        switch insight.severity {
        case .mild: return .green
        case .moderate: return .orange
        case .severe: return .red
        }
    }
}

#Preview {
    HealthIssueCard(issue: HealthIssue(
        userMessage: "I've been having headaches for the past few days",
        aiResponse: "Headaches can have various causes...",
        diagnosisInsight: DiagnosisInsight(
            condition: "Tension Headache",
            confidence: 72,
            description: "Based on your symptoms...",
            recommendations: ["Rest", "Stay hydrated"],
            severity: .mild
        )
    ))
    .padding()
}

