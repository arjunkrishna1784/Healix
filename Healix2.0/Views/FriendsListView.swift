//
//  FriendsListView.swift
//  MedBot
//
//  Created by Arjun Krishnamurthy on 12/16/25.
//

import SwiftUI

struct FriendsListView: View {
    @StateObject private var friendsService = FriendsService.shared
    @State private var showAddFriend = false
    @State private var friendEmail = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Gradient Background
                Color.healixLightGradient()
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Add Friend Section
                        Button(action: { showAddFriend = true }) {
                            HStack {
                                Image(systemName: "person.badge.plus")
                                    .font(.title2)
                                Text("Add Friend")
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
                        
                        // Competitions Section
                        NavigationLink(destination: WorkoutCompetitionView()) {
                            HStack {
                                Image(systemName: "trophy.fill")
                                    .font(.title2)
                                Text("Workout Competitions")
                                    .fontWeight(.semibold)
                                Spacer()
                                Image(systemName: "chevron.right")
                            }
                            .padding()
                            .background(Color(.systemBackground))
                            .cornerRadius(15)
                            .shadow(color: .black.opacity(0.1), radius: 5)
                        }
                        .padding(.horizontal)
                        
                        // Friends List
                        LazyVStack(spacing: 16) {
                            ForEach(friendsService.friends) { friend in
                                NavigationLink(destination: FriendProfileView(friend: friend)) {
                                    FriendCard(friend: friend)
                                }
                                .buttonStyle(PlainButtonStyle())
                                .transition(.scale.combined(with: .opacity))
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle("Friends")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showAddFriend) {
                AddFriendView(friendEmail: $friendEmail, isPresented: $showAddFriend)
            }
        }
    }
}

struct FriendCard: View {
    let friend: Friend
    @StateObject private var friendsService = FriendsService.shared
    
    var body: some View {
        HStack(spacing: 16) {
            // Avatar
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 60, height: 60)
                
                Text(friend.user.name.prefix(1).uppercased())
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            .shadow(color: .blue.opacity(0.3), radius: 5)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(friend.user.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(friend.user.email)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                HStack {
                    Circle()
                        .fill(statusColor)
                        .frame(width: 8, height: 8)
                    Text(friend.status.rawValue.capitalized)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            if friend.status == .pending {
                Button(action: { friendsService.acceptFriend(friend) }) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.green)
                }
            }
            
            Button(action: { friendsService.removeFriend(friend) }) {
                Image(systemName: "trash")
                    .font(.title3)
                    .foregroundColor(.red)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 2)
    }
    
    private var statusColor: Color {
        switch friend.status {
        case .accepted: return .green
        case .pending: return .orange
        case .blocked: return .red
        }
    }
}

struct AddFriendView: View {
    @Binding var friendEmail: String
    @Binding var isPresented: Bool
    @State private var isLoading = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                TextField("Friend's Email", text: $friendEmail)
                    .textFieldStyle(CustomTextFieldStyle())
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding(.horizontal)
                
                Button(action: addFriend) {
                    HStack {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Text("Send Friend Request")
                                .fontWeight(.semibold)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .foregroundColor(.white)
                    .cornerRadius(15)
                }
                .disabled(isLoading || friendEmail.isEmpty)
                .padding(.horizontal)
                
                Spacer()
            }
            .padding(.top)
            .navigationTitle("Add Friend")
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
    
    private func addFriend() {
        isLoading = true
        Task {
            let success = await FriendsService.shared.addFriend(email: friendEmail)
            await MainActor.run {
                isLoading = false
                if success {
                    isPresented = false
                    friendEmail = ""
                }
            }
        }
    }
}

#Preview {
    FriendsListView()
}

