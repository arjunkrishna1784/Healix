//
//  WorkoutDetailView.swift
//  Healix
//
//  Created by Arjun Krishnamurthy on 12/16/25.
//

import SwiftUI

struct WorkoutDetailView: View {
    let workout: Workout
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header Card
                VStack(spacing: 16) {
                    Image(systemName: workout.workoutType.icon)
                        .font(.system(size: 60))
                        .foregroundStyle(Color.healixGradient())
                    
                    Text(workout.workoutType.rawValue)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text(workout.startTime, style: .date)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(20)
                .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 2)
                
                // Duration Card
                MetricCard(
                    title: "Duration",
                    value: formatDuration(workout.duration),
                    icon: "clock.fill",
                    color: .yellow
                )
                
                // Metrics Grid
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    MetricCard(
                        title: "Steps",
                        value: "\(Int(workout.steps))",
                        icon: "figure.walk",
                        color: .blue
                    )
                    
                    MetricCard(
                        title: "Calories",
                        value: "\(Int(workout.calories))",
                        icon: "flame.fill",
                        color: .orange
                    )
                    
                    MetricCard(
                        title: "Distance",
                        value: String(format: "%.2f km", workout.distance / 1000),
                        icon: "location.fill",
                        color: .green
                    )
                    
                    MetricCard(
                        title: "Avg Pace",
                        value: calculatePace(),
                        icon: "speedometer",
                        color: .purple
                    )
                }
                
                // Charts Section
                if workout.duration > 0 {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Workout Metrics")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        // Simple metric visualization
                        VStack(spacing: 12) {
                            MetricBar(
                                label: "Steps",
                                value: workout.steps,
                                maxValue: 20000,
                                color: .blue
                            )
                            
                            MetricBar(
                                label: "Calories",
                                value: workout.calories,
                                maxValue: 1000,
                                color: .orange
                            )
                            
                            MetricBar(
                                label: "Distance (km)",
                                value: workout.distance / 1000,
                                maxValue: 10,
                                color: .green
                            )
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(20)
                    .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 2)
                }
            }
            .padding()
        }
        .background(Color.healixLightGradient())
        .navigationTitle("Workout Details")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func formatDuration(_ seconds: TimeInterval) -> String {
        let hours = Int(seconds) / 3600
        let minutes = (Int(seconds) % 3600) / 60
        let secs = Int(seconds) % 60
        
        if hours > 0 {
            return String(format: "%dh %dm %ds", hours, minutes, secs)
        } else {
            return String(format: "%dm %ds", minutes, secs)
        }
    }
    
    private func calculatePace() -> String {
        guard workout.duration > 0 && workout.distance > 0 else { return "N/A" }
        let paceSeconds = workout.duration / (workout.distance / 1000) // seconds per km
        let minutes = Int(paceSeconds) / 60
        let seconds = Int(paceSeconds) % 60
        return String(format: "%d:%02d min/km", minutes, seconds)
    }
}

struct MetricCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

struct MetricBar: View {
    let label: String
    let value: Double
    let maxValue: Double
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(label)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Spacer()
                Text(String(format: "%.1f", value))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color(.systemGray5))
                        .frame(height: 12)
                        .cornerRadius(6)
                    
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [color, color.opacity(0.7)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * CGFloat(min(value / maxValue, 1.0)), height: 12)
                        .cornerRadius(6)
                        .animation(.spring(response: 0.5), value: value)
                }
            }
            .frame(height: 12)
        }
    }
}

#Preview {
    NavigationStack {
        WorkoutDetailView(workout: Workout(
            userId: UUID(),
            workoutType: .running
        ))
    }
}

