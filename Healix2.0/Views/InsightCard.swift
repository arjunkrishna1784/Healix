//
//  InsightCard.swift
//  Healix
//
//  Created by Arjun Krishnamurthy on 12/16/25.
//

import SwiftUI

struct InsightCard: View {
    let insight: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "lightbulb.fill")
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.yellow, .orange],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .font(.title2)
                Text("Daily Health Insight")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
            }
            
            Text(insight)
                .font(.body)
                .foregroundColor(.primary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding()
        .background(
            LinearGradient(
                colors: [Color(.systemBackground), Color.yellow.opacity(0.05)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(20)
        .shadow(color: Color.yellow.opacity(0.2), radius: 12, x: 0, y: 4)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.yellow.opacity(0.2), lineWidth: 1)
        )
    }
}

#Preview {
    InsightCard(insight: "Staying hydrated throughout the day can improve cognitive function and energy levels. Aim for 8 glasses of water daily.")
        .padding()
}

