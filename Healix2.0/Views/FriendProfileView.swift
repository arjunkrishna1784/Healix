//
//  FriendProfileView.swift
//  MedBot
//
//  Created by Arjun Krishnamurthy on 12/16/25.
//

import SwiftUI

struct FriendProfileView: View {
    let friend: Friend
    @EnvironmentObject var settings: AppSettings
    @StateObject private var workoutService = WorkoutService.shared
    @State private var friendMetrics: FriendMetrics?
    
    // In a real app, this would check the friend's privacy settings from their profile
    // For now, we'll use a mock check
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Profile Header
                VStack(spacing: 16) {
                    // Profile Image
                    if let imageData = getFriendImageData(),
                       let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.blue, lineWidth: 4))
                            .shadow(color: .blue.opacity(0.3), radius: 10)
                    } else {
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [.blue, .purple],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 120, height: 120)
                            
                            Text(friend.user.name.prefix(1).uppercased())
                                .font(.system(size: 48, weight: .bold))
                                .foregroundColor(.white)
                        }
                        .shadow(color: .blue.opacity(0.3), radius: 10)
                    }
                    
                    VStack(spacing: 4) {
                        Text(friend.user.name)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text(friend.user.email)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        HStack(spacing: 8) {
                            Circle()
                                .fill(friend.status == .accepted ? Color.green : Color.orange)
                                .frame(width: 8, height: 8)
                            Text(friend.status.rawValue.capitalized)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.top, 4)
                    }
                }
                .padding(.top)
                
                // Metrics Section (if not hidden)
                if !shouldHideMetrics() {
                    VStack(spacing: 16) {
                        Text("Health Metrics")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        if let metrics = friendMetrics {
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                                FriendMetricCard(title: "Today's Steps", value: "\(Int(metrics.dailySteps))", icon: "figure.walk", color: .blue)
                                FriendMetricCard(title: "Today's Calories", value: "\(Int(metrics.dailyCalories))", icon: "flame.fill", color: .orange)
                                FriendMetricCard(title: "Total Workouts", value: "\(metrics.totalWorkouts)", icon: "dumbbell.fill", color: .purple)
                                FriendMetricCard(title: "Weekly Avg", value: "\(Int(metrics.weeklyAvgSteps))", icon: "chart.bar.fill", color: .green)
                            }
                        } else {
                            Text("No metrics available")
                                .foregroundColor(.secondary)
                                .padding()
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(16)
                } else {
                    VStack(spacing: 8) {
                        Image(systemName: "eye.slash.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.secondary)
                        Text("Metrics Hidden")
                            .font(.headline)
                        Text("This friend has chosen to hide their health metrics.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemGray6))
                    .cornerRadius(16)
                }
                
                // Recent Workouts
                if !shouldHideMetrics() {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Recent Workouts")
                            .font(.headline)
                        
                        let friendWorkouts = workoutService.workoutHistory.filter { $0.userId == friend.user.id }
                        if friendWorkouts.isEmpty {
                            Text("No workouts recorded yet")
                                .foregroundColor(.secondary)
                                .padding()
                        } else {
                            ForEach(friendWorkouts.prefix(3)) { workout in
                                WorkoutRow(workout: workout)
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(16)
                }
            }
            .padding()
        }
        .navigationTitle("Friend Profile")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            loadFriendMetrics()
        }
    }
    
    private func shouldHideMetrics() -> Bool {
        // In a real app, this would check the friend's privacy settings
        // For now, we'll use a mock check
        return false // Friend's settings would be checked here
    }
    
    private func getFriendImageData() -> Data? {
        // In a real app, this would fetch from the friend's profile
        // For now, return nil to use default avatar
        return nil
    }
    
    private func loadFriendMetrics() {
        // Mock metrics - in real app, fetch from friend's data
        friendMetrics = FriendMetrics(
            dailySteps: 8500,
            dailyCalories: 450,
            totalWorkouts: 12,
            weeklyAvgSteps: 9200
        )
    }
}

struct FriendMetrics {
    let dailySteps: Double
    let dailyCalories: Double
    let totalWorkouts: Int
    let weeklyAvgSteps: Double
}

struct FriendMetricCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
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
        .cornerRadius(12)
    }
}

struct WorkoutRow: View {
    let workout: Workout
    
    var body: some View {
        HStack {
            Image(systemName: workout.workoutType.icon)
                .foregroundColor(.blue)
                .font(.title3)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(workout.workoutType.rawValue)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Text(workout.startTime, style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(Int(workout.steps)) steps")
                    .font(.caption)
                Text(formatDuration(workout.duration))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemBackground))
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
    NavigationStack {
        FriendProfileView(friend: Friend(
            user: User(email: "friend@example.com", name: "John Doe"),
            status: .accepted
        ))
    }
}

