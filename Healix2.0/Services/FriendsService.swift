//
//  FriendsService.swift
//  MedBot
//
//  Created by Arjun Krishnamurthy on 12/16/25.
//

import Foundation
import Combine

class FriendsService: ObservableObject {
    static let shared = FriendsService()
    
    @Published var friends: [Friend] = []
    
    private init() {
        loadFriends()
    }
    
    func loadFriends() {
        // Mock friends data - in production, fetch from API
        friends = [
            Friend(user: User(email: "sarah@example.com", name: "Sarah Johnson"), status: .accepted),
            Friend(user: User(email: "mike@example.com", name: "Mike Chen"), status: .accepted),
            Friend(user: User(email: "emma@example.com", name: "Emma Williams"), status: .pending)
        ]
    }
    
    func addFriend(email: String) async -> Bool {
        // Simulate network delay
        try? await Task.sleep(nanoseconds: 500_000_000)
        
        // Mock adding friend
        let newFriend = Friend(
            user: User(email: email, name: email.components(separatedBy: "@").first?.capitalized ?? "Friend"),
            status: .pending
        )
        
        await MainActor.run {
            friends.append(newFriend)
        }
        
        return true
    }
    
    func acceptFriend(_ friend: Friend) {
        if let index = friends.firstIndex(where: { $0.id == friend.id }) {
            friends[index].status = .accepted
        }
    }
    
    func removeFriend(_ friend: Friend) {
        friends.removeAll { $0.id == friend.id }
    }
}

