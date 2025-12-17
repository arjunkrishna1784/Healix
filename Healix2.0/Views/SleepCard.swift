//
//  SleepCard.swift
//  Healix
//
//  Created by Arjun Krishnamurthy on 12/16/25.
//

import SwiftUI

struct SleepCard: View {
    let sleepHours: Double
    let isAuthorized: Bool
    let onRequestAuthorization: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "moon.zzz.fill")
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.yellow, .orange],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .font(.title2)
                Text("Sleep")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
            }
            
            if isAuthorized {
                if sleepHours > 0 {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(alignment: .lastTextBaseline, spacing: 8) {
                            Text(String(format: "%.1f", sleepHours))
                                .font(.system(size: 48, weight: .bold))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [sleepColor, sleepColor.opacity(0.7)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                            Text("hours")
                                .font(.title3)
                                .foregroundColor(.secondary)
                        }
                        
                        Text(sleepQuality)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        // Sleep quality indicator
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                Rectangle()
                                    .fill(Color(.systemGray5))
                                    .frame(height: 8)
                                    .cornerRadius(4)
                                
                                Rectangle()
                                    .fill(
                                        LinearGradient(
                                            colors: [sleepColor, sleepColor.opacity(0.7)],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .frame(width: geometry.size.width * CGFloat(min(sleepHours / 8.0, 1.0)), height: 8)
                                    .cornerRadius(4)
                                    .animation(.spring(response: 1.0, dampingFraction: 0.8), value: sleepHours)
                            }
                        }
                        .frame(height: 8)
                    }
                } else {
                    VStack(spacing: 12) {
                        Text("No sleep data available")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                        
                        Text("Sleep data will appear here once recorded in Health app")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                }
            } else {
                VStack(spacing: 12) {
                    Text("Connect HealthKit to see your sleep data")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                    
                    Button(action: onRequestAuthorization) {
                        HStack {
                            Image(systemName: "moon.fill")
                            Text("Enable HealthKit")
                        }
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(
                            LinearGradient(
                                colors: [.yellow, .orange],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
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
    
    private var sleepColor: Color {
        if sleepHours >= 7 && sleepHours <= 9 {
            return .green
        } else if sleepHours >= 6 && sleepHours < 7 || sleepHours > 9 && sleepHours <= 10 {
            return .orange
        } else {
            return .red
        }
    }
    
    private var sleepQuality: String {
        if sleepHours >= 7 && sleepHours <= 9 {
            return "Excellent sleep duration! Keep it up."
        } else if sleepHours >= 6 && sleepHours < 7 {
            return "Good, but aim for 7-9 hours for optimal health."
        } else if sleepHours > 9 && sleepHours <= 10 {
            return "Adequate, though slightly above recommended range."
        } else if sleepHours > 0 && sleepHours < 6 {
            return "Insufficient sleep. Try to get more rest."
        } else {
            return "Recommended: 7-9 hours per night"
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        SleepCard(sleepHours: 7.5, isAuthorized: true, onRequestAuthorization: {})
        SleepCard(sleepHours: 5.2, isAuthorized: true, onRequestAuthorization: {})
        SleepCard(sleepHours: 0, isAuthorized: false, onRequestAuthorization: {})
    }
    .padding()
}

