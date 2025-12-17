//
//  ActivityCard.swift
//  MedBot
//
//  Created by Arjun Krishnamurthy on 12/16/25.
//

import SwiftUI

struct ActivityCard: View {
    let stepCount: Double
    let activeCalories: Double
    let isAuthorized: Bool
    let onRequestAuthorization: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "figure.walk")
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.yellow, .orange],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .font(.title2)
                Text("Today's Activity")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
            }
            
            if isAuthorized {
                VStack(alignment: .leading, spacing: 12) {
                    // Step Count
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Steps")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text("\(Int(stepCount))")
                                .font(.title2)
                                .fontWeight(.semibold)
                        }
                        Spacer()
                    }
                    
                    Divider()
                    
                    // Active Calories
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Active Calories")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text("\(Int(activeCalories))")
                                .font(.title2)
                                .fontWeight(.semibold)
                        }
                        Spacer()
                    }
                }
            } else {
                VStack(spacing: 12) {
                    Text("Connect HealthKit to see your activity data")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                    
                    Button(action: onRequestAuthorization) {
                        HStack {
                            Image(systemName: "heart.fill")
                            Text("Enable HealthKit")
                        }
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.blue)
                        .cornerRadius(10)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
            }
        }
        .padding()
        .background(
            LinearGradient(
                colors: [Color(.systemBackground), Color.blue.opacity(0.05)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(20)
        .shadow(color: Color.blue.opacity(0.2), radius: 12, x: 0, y: 4)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.blue.opacity(0.2), lineWidth: 1)
        )
    }
}

#Preview {
    VStack(spacing: 20) {
        ActivityCard(
            stepCount: 8542,
            activeCalories: 342,
            isAuthorized: true,
            onRequestAuthorization: {}
        )
        ActivityCard(
            stepCount: 0,
            activeCalories: 0,
            isAuthorized: false,
            onRequestAuthorization: {}
        )
    }
    .padding()
}

