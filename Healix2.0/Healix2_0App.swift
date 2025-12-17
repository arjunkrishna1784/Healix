//
//  MedBotApp.swift
//  MedBot
//
//  Created by Arjun Krishnamurthy on 12/16/25.
//

import SwiftUI

@main
struct MedBotApp: App {
    @StateObject private var healthKitManager = HealthKitManager()
    @StateObject private var authService = AuthService.shared
    @StateObject private var appSettings = AppSettings.shared
    @AppStorage("hasSeenDisclaimer") private var hasSeenDisclaimer = false
    @State private var showDisclaimer = false
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(healthKitManager)
                .environmentObject(authService)
                .environmentObject(appSettings)
                .preferredColorScheme(appSettings.selectedTheme.colorScheme)
                .onAppear {
                    showDisclaimer = !hasSeenDisclaimer && authService.isAuthenticated
                }
                .sheet(isPresented: $showDisclaimer) {
                    DisclaimerView(hasSeenDisclaimer: $hasSeenDisclaimer)
                }
                .onChange(of: hasSeenDisclaimer) { newValue in
                    if newValue {
                        showDisclaimer = false
                    }
                }
                .onChange(of: authService.isAuthenticated) { isAuthenticated in
                    if isAuthenticated {
                        showDisclaimer = !hasSeenDisclaimer
                    }
                }
        }
    }
}
