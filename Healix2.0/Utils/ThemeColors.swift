//
//  ThemeColors.swift
//  Healix
//
//  Created by Arjun Krishnamurthy on 12/16/25.
//

import SwiftUI

extension Color {
    // Healix Yellow Theme Colors
    static let healixPrimary = Color.yellow
    static let healixSecondary = Color.orange
    static let healixAccent = Color(red: 1.0, green: 0.84, blue: 0.0) // Gold yellow
    
    static func healixGradient(start: UnitPoint = .topLeading, end: UnitPoint = .bottomTrailing) -> some ShapeStyle {
        LinearGradient(
            colors: [healixPrimary.opacity(0.8), healixSecondary.opacity(0.8)],
            startPoint: start,
            endPoint: end
        )
    }
    
    static func healixLightGradient(start: UnitPoint = .topLeading, end: UnitPoint = .bottomTrailing) -> some View {
        LinearGradient(
            colors: [healixPrimary.opacity(0.1), healixSecondary.opacity(0.1)],
            startPoint: start,
            endPoint: end
        )
    }
}

