//
//  HeartRateCard.swift
//  Healix
//
//  Created by Arjun Krishnamurthy on 12/16/25.
//

import SwiftUI

struct HeartRateCard: View {
    let heartRate: Double
    let isAuthorized: Bool
    let onRequestAuthorization: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "heart.fill")
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.red, .pink],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .font(.title2)
                Text("Heart Rate")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
            }
            
            if isAuthorized {
                if heartRate > 0 {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(alignment: .lastTextBaseline, spacing: 8) {
                            Text("\(Int(heartRate))")
                                .font(.system(size: 48, weight: .bold))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [heartRateColor, heartRateColor.opacity(0.7)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                            Text("bpm")
                                .font(.title3)
                                .foregroundColor(.secondary)
                        }
                        
                        Text(heartRateStatus)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        // Heart rate zone indicator
                        HStack(spacing: 8) {
                            ForEach(0..<5) { index in
                                Circle()
                                    .fill(index < heartRateZone ? heartRateColor : Color(.systemGray4))
                                    .frame(width: 12, height: 12)
                                    .animation(.spring(response: 0.5), value: heartRateZone)
                            }
                            Spacer()
                            Text(heartRateZoneText)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                } else {
                    VStack(spacing: 12) {
                        Text("No heart rate data available")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                        
                        Text("Heart rate data will appear here once recorded in Health app")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                }
            } else {
                VStack(spacing: 12) {
                    Text("Connect HealthKit to see your heart rate")
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
                        .background(
                            LinearGradient(
                                colors: [.red, .pink],
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
                colors: [Color(.systemBackground), Color.red.opacity(0.05)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(20)
        .shadow(color: Color.red.opacity(0.2), radius: 12, x: 0, y: 4)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.red.opacity(0.2), lineWidth: 1)
        )
    }
    
    private var heartRateColor: Color {
        if heartRate >= 60 && heartRate <= 100 {
            return .green
        } else if heartRate >= 50 && heartRate < 60 || heartRate > 100 && heartRate <= 120 {
            return .orange
        } else {
            return .red
        }
    }
    
    private var heartRateStatus: String {
        if heartRate >= 60 && heartRate <= 100 {
            return "Normal resting heart rate"
        } else if heartRate < 60 {
            return "Bradycardia (low heart rate)"
        } else if heartRate > 100 && heartRate <= 120 {
            return "Elevated heart rate"
        } else if heartRate > 120 {
            return "Tachycardia (high heart rate)"
        } else {
            return "Normal range: 60-100 bpm"
        }
    }
    
    private var heartRateZone: Int {
        if heartRate < 60 {
            return 1
        } else if heartRate >= 60 && heartRate <= 100 {
            return 3
        } else if heartRate > 100 && heartRate <= 120 {
            return 4
        } else {
            return 5
        }
    }
    
    private var heartRateZoneText: String {
        if heartRate < 60 {
            return "Low"
        } else if heartRate >= 60 && heartRate <= 100 {
            return "Normal"
        } else if heartRate > 100 && heartRate <= 120 {
            return "Elevated"
        } else {
            return "High"
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        HeartRateCard(heartRate: 72, isAuthorized: true, onRequestAuthorization: {})
        HeartRateCard(heartRate: 110, isAuthorized: true, onRequestAuthorization: {})
        HeartRateCard(heartRate: 0, isAuthorized: false, onRequestAuthorization: {})
    }
    .padding()
}

