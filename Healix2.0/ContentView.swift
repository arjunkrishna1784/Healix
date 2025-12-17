//
//  ContentView.swift
//  MedBot
//
//  Created by Arjun Krishnamurthy on 12/16/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var healthKitManager: HealthKitManager
    @EnvironmentObject var authService: AuthService
    
    var body: some View {
        if authService.isAuthenticated {
            TabView {
                DashboardView()
                    .tabItem {
                        Label("Dashboard", systemImage: "house.fill")
                    }
                
                WorkoutDashboardView()
                    .tabItem {
                        Label("Workouts", systemImage: "figure.run")
                    }
                
                ChatView()
                    .tabItem {
                        Label("AI Assistant", systemImage: "message.fill")
                    }
                
                NewsView()
                    .tabItem {
                        Label("News", systemImage: "newspaper.fill")
                    }
                
                FriendsListView()
                    .tabItem {
                        Label("Friends", systemImage: "person.2.fill")
                    }
                
                ProfileView()
                    .tabItem {
                        Label("Profile", systemImage: "person.circle.fill")
                    }
            }
            .task {
                // Request HealthKit authorization on app launch if not already authorized
                if !healthKitManager.isAuthorized && healthKitManager.isHealthKitAvailable() {
                    await healthKitManager.requestAuthorization()
                }
            }
        } else {
            LoginView()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(HealthKitManager())
        .environmentObject(AuthService.shared)
}
