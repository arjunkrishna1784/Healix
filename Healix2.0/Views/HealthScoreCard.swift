//
//  HealthScoreCard.swift
//  MedBot
//
//  Created by Arjun Krishnamurthy on 12/16/25.
//

import SwiftUI

struct HealthScoreCard: View {
    let score: Int // 0-100
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "heart.fill")
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.pink, .red],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .font(.title2)
                Text("Daily Health Score")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
            }
            
            HStack(alignment: .lastTextBaseline, spacing: 8) {
                Text("\(score)")
                    .font(.system(size: 56, weight: .bold))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [scoreColor, scoreColor.opacity(0.7)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                Text("/ 100")
                    .font(.title3)
                    .foregroundColor(.secondary)
            }
            
            // Animated Progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color(.systemGray5))
                        .frame(height: 12)
                        .cornerRadius(6)
                    
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [scoreColor, scoreColor.opacity(0.7)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * CGFloat(score) / 100, height: 12)
                        .cornerRadius(6)
                        .animation(.spring(response: 1.0, dampingFraction: 0.8), value: score)
                }
            }
            .frame(height: 12)
            
            Text(scoreDescription)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(
            LinearGradient(
                colors: [Color(.systemBackground), scoreColor.opacity(0.05)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(20)
        .shadow(color: scoreColor.opacity(0.3), radius: 12, x: 0, y: 4)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(scoreColor.opacity(0.2), lineWidth: 1)
        )
    }
    
    private var scoreColor: Color {
        switch score {
        case 80...100:
            return .green
        case 60..<80:
            return .orange
        default:
            return .red
        }
    }
    
    private var scoreDescription: String {
        switch score {
        case 80...100:
            return "Excellent health day! Keep it up."
        case 60..<80:
            return "Good day. Room for improvement."
        default:
            return "Focus on rest and recovery today."
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        HealthScoreCard(score: 85)
        HealthScoreCard(score: 65)
        HealthScoreCard(score: 45)
    }
    .padding()
}

