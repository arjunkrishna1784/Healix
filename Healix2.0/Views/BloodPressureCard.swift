//
//  BloodPressureCard.swift
//  MedBot
//
//  Created by Arjun Krishnamurthy on 12/16/25.
//

import SwiftUI

struct BloodPressureCard: View {
    let systolic: Double
    let diastolic: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "heart.circle.fill")
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.red, .pink],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                Text("Blood Pressure")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
            }
            
            if systolic > 0 && diastolic > 0 {
                HStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("\(Int(systolic))")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(bloodPressureColor)
                        Text("Systolic")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Text("/")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.secondary)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("\(Int(diastolic))")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(bloodPressureColor)
                        Text("Diastolic")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text(bloodPressureStatus)
                            .font(.headline)
                            .foregroundColor(bloodPressureColor)
                        Text("mmHg")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            } else {
                VStack(spacing: 12) {
                    Text("No blood pressure data available")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                    
                    Text("Connect a blood pressure monitor or enter data manually in Health app")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
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
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 2)
    }
    
    private var bloodPressureColor: Color {
        if systolic >= 140 || diastolic >= 90 {
            return .red
        } else if systolic >= 120 || diastolic >= 80 {
            return .orange
        } else {
            return .green
        }
    }
    
    private var bloodPressureStatus: String {
        if systolic >= 140 || diastolic >= 90 {
            return "High"
        } else if systolic >= 120 || diastolic >= 80 {
            return "Elevated"
        } else {
            return "Normal"
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        BloodPressureCard(systolic: 120, diastolic: 80)
        BloodPressureCard(systolic: 135, diastolic: 85)
        BloodPressureCard(systolic: 0, diastolic: 0)
    }
    .padding()
}

