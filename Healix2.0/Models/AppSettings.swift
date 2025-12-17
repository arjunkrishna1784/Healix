//
//  AppSettings.swift
//  MedBot
//
//  Created by Arjun Krishnamurthy on 12/16/25.
//

import Foundation
import SwiftUI

class AppSettings: ObservableObject {
    static let shared = AppSettings()
    
    @Published var hideMetricsFromFriends: Bool = false
    @Published var selectedTheme: AppTheme = .yellow
    @Published var profileImageData: Data?
    
    private let hideMetricsKey = "hideMetricsFromFriends"
    private let themeKey = "selectedTheme"
    private let profileImageKey = "profileImageData"
    
    private init() {
        loadSettings()
    }
    
    func loadSettings() {
        hideMetricsFromFriends = UserDefaults.standard.bool(forKey: hideMetricsKey)
        
        if let themeRaw = UserDefaults.standard.string(forKey: themeKey),
           let theme = AppTheme(rawValue: themeRaw) {
            selectedTheme = theme
        }
        
        if let imageData = UserDefaults.standard.data(forKey: profileImageKey) {
            profileImageData = imageData
        }
    }
    
    func saveSettings() {
        UserDefaults.standard.set(hideMetricsFromFriends, forKey: hideMetricsKey)
        UserDefaults.standard.set(selectedTheme.rawValue, forKey: themeKey)
        
        if let imageData = profileImageData {
            UserDefaults.standard.set(imageData, forKey: profileImageKey)
        } else {
            UserDefaults.standard.removeObject(forKey: profileImageKey)
        }
    }
}

enum AppTheme: String, CaseIterable {
    case system = "System"
    case light = "Light"
    case dark = "Dark"
    case yellow = "Yellow"
    case blue = "Blue"
    case purple = "Purple"
    case green = "Green"
    
    var colorScheme: ColorScheme? {
        switch self {
        case .system: return nil
        case .light: return .light
        case .dark: return .dark
        case .yellow, .blue, .purple, .green: return nil
        }
    }
    
    var primaryColor: Color {
        switch self {
        case .system, .light, .dark: return .yellow
        case .yellow: return .yellow
        case .blue: return .blue
        case .purple: return .purple
        case .green: return .green
        }
    }
}

