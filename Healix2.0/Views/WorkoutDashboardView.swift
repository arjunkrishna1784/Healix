//
//  WorkoutDashboardView.swift
//  MedBot
//
//  Created by Arjun Krishnamurthy on 12/16/25.
//

import SwiftUI

struct WorkoutDashboardView: View {
    @EnvironmentObject var healthKitManager: HealthKitManager
    @StateObject private var workoutService = WorkoutService.shared
    @EnvironmentObject var authService: AuthService
    @State private var selectedWorkoutType: WorkoutType = .walking
    @State private var showWorkoutTypePicker = false
    @State private var workoutStartTime: Date?
    @State private var currentSteps: Double = 0
    @State private var currentCalories: Double = 0
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Gradient Background
                Color.healixLightGradient()
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Active Workout Section
                        if let activeWorkout = workoutService.activeWorkout {
                            ActiveWorkoutCard(
                                workout: activeWorkout,
                                currentSteps: currentSteps,
                                currentCalories: currentCalories,
                                onEnd: {
                                    endWorkout()
                                },
                                onCancel: {
                                    workoutService.cancelWorkout()
                                }
                            )
                        } else {
                            // Start Workout Section
                            StartWorkoutCard(
                                selectedType: $selectedWorkoutType,
                                onStart: {
                                    startWorkout()
                                }
                            )
                        }
                        
                        // Workout History
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Recent Workouts")
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            if workoutService.workoutHistory.isEmpty {
                                VStack(spacing: 12) {
                                    Image(systemName: "figure.walk")
                                        .font(.system(size: 50))
                                        .foregroundColor(.gray.opacity(0.5))
                                    Text("No workouts yet")
                                        .foregroundColor(.secondary)
                                    Text("Start your first workout to see it here!")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 40)
                            } else {
                                ForEach(workoutService.workoutHistory.prefix(5)) { workout in
                                    NavigationLink(destination: WorkoutDetailView(workout: workout)) {
                                        WorkoutHistoryCard(workout: workout)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(20)
                        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 2)
                    }
                    .padding()
                }
            }
            .navigationTitle("Workouts")
            .task {
                if let workout = workoutService.activeWorkout {
                    startTrackingWorkout(workout)
                }
            }
        }
    }
    
    private func startWorkout() {
        guard let userId = authService.currentUser?.id else { return }
        workoutService.startWorkout(userId: userId, type: selectedWorkoutType)
        if let workout = workoutService.activeWorkout {
            startTrackingWorkout(workout)
        }
    }
    
    private func startTrackingWorkout(_ workout: Workout) {
        workoutStartTime = workout.startTime
        Task {
            while workoutService.activeWorkout != nil {
                // Update metrics from HealthKit
                currentSteps = healthKitManager.stepCount
                currentCalories = healthKitManager.activeCalories
                
                // Refresh HealthKit data
                await healthKitManager.fetchTodayData()
                
                try? await Task.sleep(nanoseconds: 5_000_000_000) // Update every 5 seconds
            }
        }
    }
    
    private func endWorkout() {
        guard let userId = authService.currentUser?.id else { return }
        
        // Calculate distance (rough estimate: 0.0008 km per step)
        let distance = currentSteps * 0.0008 * 1000 // Convert to meters
        
        workoutService.endWorkout(
            steps: currentSteps,
            calories: currentCalories,
            distance: distance
        )
        
        currentSteps = 0
        currentCalories = 0
        workoutStartTime = nil
    }
}

struct StartWorkoutCard: View {
    @Binding var selectedType: WorkoutType
    let onStart: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "figure.run")
                .font(.system(size: 60))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
            
            Text("Ready to Workout?")
                .font(.title2)
                .fontWeight(.bold)
            
            // Workout Type Picker
            Menu {
                ForEach(WorkoutType.allCases, id: \.self) { type in
                    Button(action: { selectedType = type }) {
                        HStack {
                            Image(systemName: type.icon)
                            Text(type.rawValue)
                            if selectedType == type {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            } label: {
                HStack {
                    Image(systemName: selectedType.icon)
                    Text(selectedType.rawValue)
                    Spacer()
                    Image(systemName: "chevron.down")
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
            }
            
            Button(action: onStart) {
                HStack {
                    Image(systemName: "play.circle.fill")
                    Text("Start Workout")
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.healixGradient())
                .foregroundColor(.white)
                .cornerRadius(15)
                .shadow(color: .yellow.opacity(0.3), radius: 10)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 2)
    }
}

struct ActiveWorkoutCard: View {
    let workout: Workout
    let currentSteps: Double
    let currentCalories: Double
    let onEnd: () -> Void
    let onCancel: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Image(systemName: workout.workoutType.icon)
                    .font(.title)
                    .foregroundColor(.yellow)
                Text(workout.workoutType.rawValue)
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
            }
            
            // Timer
            Text(formatDuration(Date().timeIntervalSince(workout.startTime)))
                .font(.system(size: 48, weight: .bold))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
            
            // Metrics
            HStack(spacing: 30) {
                VStack {
                    Text("\(Int(currentSteps))")
                        .font(.title2)
                        .fontWeight(.bold)
                    Text("Steps")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                VStack {
                    Text("\(Int(currentCalories))")
                        .font(.title2)
                        .fontWeight(.bold)
                    Text("Calories")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            // Action Buttons
            HStack(spacing: 16) {
                Button(action: onCancel) {
                    Text("Cancel")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.systemGray5))
                        .foregroundColor(.primary)
                        .cornerRadius(12)
                }
                
                Button(action: onEnd) {
                    HStack {
                        Image(systemName: "stop.circle.fill")
                        Text("End Workout")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        LinearGradient(
                            colors: [.red, .orange],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 2)
    }
    
    private func formatDuration(_ seconds: TimeInterval) -> String {
        let hours = Int(seconds) / 3600
        let minutes = (Int(seconds) % 3600) / 60
        let secs = Int(seconds) % 60
        
        if hours > 0 {
            return String(format: "%02d:%02d:%02d", hours, minutes, secs)
        } else {
            return String(format: "%02d:%02d", minutes, secs)
        }
    }
}

struct WorkoutHistoryCard: View {
    let workout: Workout
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: workout.workoutType.icon)
                .font(.title2)
                .foregroundColor(.blue)
                .frame(width: 50)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(workout.workoutType.rawValue)
                    .font(.headline)
                Text(workout.startTime, style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(Int(workout.steps)) steps")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Text(formatDuration(workout.duration))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    private func formatDuration(_ seconds: TimeInterval) -> String {
        let hours = Int(seconds) / 3600
        let minutes = (Int(seconds) % 3600) / 60
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
}

#Preview {
    WorkoutDashboardView()
        .environmentObject(HealthKitManager())
        .environmentObject(AuthService.shared)
}

