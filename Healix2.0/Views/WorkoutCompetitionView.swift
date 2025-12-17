//
//  WorkoutCompetitionView.swift
//  MedBot
//
//  Created by Arjun Krishnamurthy on 12/16/25.
//

import SwiftUI

struct WorkoutCompetitionView: View {
    @StateObject private var workoutService = WorkoutService.shared
    @StateObject private var friendsService = FriendsService.shared
    @EnvironmentObject var authService: AuthService
    @State private var showCreateCompetition = false
    @State private var competitionName = ""
    @State private var selectedEndDate = Date().addingTimeInterval(7 * 24 * 60 * 60) // 7 days from now
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Gradient Background
                Color.healixLightGradient()
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Create Competition Button
                        Button(action: { showCreateCompetition = true }) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                Text("Create Competition")
                                    .fontWeight(.semibold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                LinearGradient(
                                    colors: [.yellow, .orange],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .foregroundColor(.white)
                            .cornerRadius(15)
                            .shadow(color: .blue.opacity(0.3), radius: 10)
                        }
                        .padding(.horizontal)
                        
                        // Active Competitions
                        if workoutService.competitions.isEmpty {
                            VStack(spacing: 16) {
                                Image(systemName: "trophy.fill")
                                    .font(.system(size: 60))
                                    .foregroundColor(.gray.opacity(0.5))
                                Text("No Competitions Yet")
                                    .font(.headline)
                                Text("Create a competition with your friends to see who can be the most active!")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 60)
                        } else {
                            ForEach(workoutService.competitions) { competition in
                                CompetitionCard(competition: competition)
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Competitions")
            .sheet(isPresented: $showCreateCompetition) {
                CreateCompetitionView(
                    competitionName: $competitionName,
                    endDate: $selectedEndDate,
                    isPresented: $showCreateCompetition
                )
            }
        }
    }
}

struct CompetitionCard: View {
    let competition: WorkoutCompetition
    @StateObject private var workoutService = WorkoutService.shared
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            HStack {
                Image(systemName: "trophy.fill")
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.yellow, .orange],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .font(.title2)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(competition.name)
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    Text("Ends: \(competition.endDate, style: .date)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            
            Divider()
            
            // Leaderboard
            if competition.leaderboard.isEmpty {
                Text("No participants yet")
                    .foregroundColor(.secondary)
                    .padding()
            } else {
                VStack(spacing: 12) {
                    ForEach(Array(competition.leaderboard.enumerated()), id: \.element.id) { index, entry in
                        LeaderboardRow(entry: entry, rank: index + 1)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 2)
    }
}

struct LeaderboardRow: View {
    let entry: CompetitionEntry
    let rank: Int
    
    var body: some View {
        HStack(spacing: 12) {
            // Rank Badge
            ZStack {
                Circle()
                    .fill(rankColor)
                    .frame(width: 40, height: 40)
                Text("\(rank)")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(entry.userName)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                HStack(spacing: 16) {
                    Label("\(Int(entry.totalSteps))", systemImage: "figure.walk")
                    Label("\(Int(entry.totalCalories))", systemImage: "flame.fill")
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Trophy for top 3
            if rank <= 3 {
                Image(systemName: rank == 1 ? "trophy.fill" : rank == 2 ? "trophy.fill" : "trophy.fill")
                    .foregroundColor(rankColor)
                    .font(.title3)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    private var rankColor: Color {
        switch rank {
        case 1: return .yellow
        case 2: return .gray
        case 3: return Color(red: 0.8, green: 0.5, blue: 0.2) // Bronze
        default: return .blue
        }
    }
}

struct CreateCompetitionView: View {
    @Binding var competitionName: String
    @Binding var endDate: Date
    @Binding var isPresented: Bool
    @StateObject private var workoutService = WorkoutService.shared
    @StateObject private var friendsService = FriendsService.shared
    @EnvironmentObject var authService: AuthService
    @State private var selectedFriends: Set<UUID> = []
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Competition Details") {
                    TextField("Competition Name", text: $competitionName)
                    
                    DatePicker("End Date", selection: $endDate, displayedComponents: .date)
                }
                
                Section("Participants") {
                    if let currentUser = authService.currentUser {
                        HStack {
                            Text(currentUser.name)
                            Spacer()
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                        }
                    }
                    
                    ForEach(friendsService.friends.filter { $0.status == .accepted }) { friend in
                        Button(action: {
                            if selectedFriends.contains(friend.user.id) {
                                selectedFriends.remove(friend.user.id)
                            } else {
                                selectedFriends.insert(friend.user.id)
                            }
                        }) {
                            HStack {
                                Text(friend.user.name)
                                Spacer()
                                if selectedFriends.contains(friend.user.id) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.blue)
                                } else {
                                    Image(systemName: "circle")
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }
                }
                
                Section {
                    Button(action: createCompetition) {
                        Text("Create Competition")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                            .padding()
                            .background(
                                LinearGradient(
                                    colors: [.yellow, .orange],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(10)
                    }
                    .disabled(competitionName.isEmpty)
                }
            }
            .navigationTitle("New Competition")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
            }
        }
    }
    
    private func createCompetition() {
        guard let currentUser = authService.currentUser else { return }
        
        var participants = [currentUser.id]
        participants.append(contentsOf: selectedFriends)
        
        workoutService.createCompetition(
            name: competitionName,
            startDate: Date(),
            endDate: endDate,
            participants: participants
        )
        
        competitionName = ""
        selectedFriends = []
        isPresented = false
    }
}

#Preview {
    WorkoutCompetitionView()
        .environmentObject(AuthService.shared)
}

