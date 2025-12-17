//
//  User.swift
//  MedBot
//
//  Created by Arjun Krishnamurthy on 12/16/25.
//

import Foundation

struct User: Identifiable, Codable {
    let id: UUID
    var email: String
    var name: String
    var profileImageURL: String?
    var createdAt: Date
    
    init(email: String, name: String, profileImageURL: String? = nil) {
        self.id = UUID()
        self.email = email
        self.name = name
        self.profileImageURL = profileImageURL
        self.createdAt = Date()
    }
}

struct Friend: Identifiable, Codable {
    let id: UUID
    var user: User
    var status: FriendStatus
    var addedAt: Date
    
    init(user: User, status: FriendStatus = .pending) {
        self.id = UUID()
        self.user = user
        self.status = status
        self.addedAt = Date()
    }
}

enum FriendStatus: String, Codable {
    case pending
    case accepted
    case blocked
}

