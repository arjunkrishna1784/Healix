//
//  AuthService.swift
//  MedBot
//
//  Created by Arjun Krishnamurthy on 12/16/25.
//

import Foundation
import Combine

class AuthService: ObservableObject {
    static let shared = AuthService()
    
    @Published var currentUser: User?
    @Published var isAuthenticated: Bool = false
    
    private init() {
        // Check if user is already logged in (stored locally)
        if let userData = UserDefaults.standard.data(forKey: "currentUser"),
           let user = try? JSONDecoder().decode(User.self, from: userData) {
            self.currentUser = user
            self.isAuthenticated = true
        }
    }
    
    func signIn(email: String, password: String) async -> Bool {
        // Simulate network delay
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        // Mock authentication - in production, this would call a real API
        // For demo purposes, accept any email/password
        let user = User(email: email, name: email.components(separatedBy: "@").first?.capitalized ?? "User")
        
        await MainActor.run {
            self.currentUser = user
            self.isAuthenticated = true
            
            // Save to UserDefaults
            if let userData = try? JSONEncoder().encode(user) {
                UserDefaults.standard.set(userData, forKey: "currentUser")
            }
        }
        
        return true
    }
    
    func signUp(email: String, password: String, name: String) async -> Bool {
        // Simulate network delay
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        // Mock registration
        let user = User(email: email, name: name)
        
        await MainActor.run {
            self.currentUser = user
            self.isAuthenticated = true
            
            // Save to UserDefaults
            if let userData = try? JSONEncoder().encode(user) {
                UserDefaults.standard.set(userData, forKey: "currentUser")
            }
        }
        
        return true
    }
    
    func signOut() {
        currentUser = nil
        isAuthenticated = false
        UserDefaults.standard.removeObject(forKey: "currentUser")
    }
}

