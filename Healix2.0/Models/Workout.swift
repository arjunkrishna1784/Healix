//
//  Workout.swift
//  MedBot
//
//  Created by Arjun Krishnamurthy on 12/16/25.
//

import Foundation

struct Workout: Identifiable, Codable {
    let id: UUID
    let userId: UUID
    let startTime: Date
    var endTime: Date?
    var duration: TimeInterval // in seconds
    var steps: Double
    var calories: Double
    var distance: Double // in meters
    var workoutType: WorkoutType
    var isActive: Bool
    
    init(userId: UUID, workoutType: WorkoutType = .walking) {
        self.id = UUID()
        self.userId = userId
        self.startTime = Date()
        self.endTime = nil
        self.duration = 0
        self.steps = 0
        self.calories = 0
        self.distance = 0
        self.workoutType = workoutType
        self.isActive = true
    }
}

enum WorkoutType: String, Codable, CaseIterable {
    case walking = "Walking"
    case running = "Running"
    case cycling = "Cycling"
    case strength = "Strength Training"
    case yoga = "Yoga"
    case other = "Other"
    
    var icon: String {
        switch self {
        case .walking: return "figure.walk"
        case .running: return "figure.run"
        case .cycling: return "bicycle"
        case .strength: return "dumbbell.fill"
        case .yoga: return "figure.flexibility"
        case .other: return "figure.mixed.cardio"
        }
    }
}

struct WorkoutCompetition: Identifiable, Codable {
    let id: UUID
    let name: String
    let startDate: Date
    let endDate: Date
    let participants: [UUID] // User IDs
    var leaderboard: [CompetitionEntry]
    
    init(name: String, startDate: Date, endDate: Date, participants: [UUID]) {
        self.id = UUID()
        self.name = name
        self.startDate = startDate
        self.endDate = endDate
        self.participants = participants
        self.leaderboard = []
    }
}

struct CompetitionEntry: Identifiable, Codable {
    let id: UUID
    let userId: UUID
    let userName: String
    var totalSteps: Double
    var totalCalories: Double
    var totalWorkouts: Int
    var rank: Int
    
    init(userId: UUID, userName: String) {
        self.id = UUID()
        self.userId = userId
        self.userName = userName
        self.totalSteps = 0
        self.totalCalories = 0
        self.totalWorkouts = 0
        self.rank = 0
    }
}

