//
//  WorkoutService.swift
//  MedBot
//
//  Created by Arjun Krishnamurthy on 12/16/25.
//

import Foundation
import Combine

class WorkoutService: ObservableObject {
    static let shared = WorkoutService()
    
    @Published var activeWorkout: Workout?
    @Published var workoutHistory: [Workout] = []
    @Published var competitions: [WorkoutCompetition] = []
    
    private init() {
        loadWorkoutHistory()
        loadCompetitions()
    }
    
    func startWorkout(userId: UUID, type: WorkoutType) {
        let workout = Workout(userId: userId, workoutType: type)
        activeWorkout = workout
    }
    
    func endWorkout(steps: Double, calories: Double, distance: Double) {
        guard var workout = activeWorkout else { return }
        
        workout.endTime = Date()
        workout.duration = workout.endTime!.timeIntervalSince(workout.startTime)
        workout.steps = steps
        workout.calories = calories
        workout.distance = distance
        workout.isActive = false
        
        workoutHistory.insert(workout, at: 0)
        activeWorkout = nil
        
        saveWorkoutHistory()
        updateCompetitions(workout: workout)
    }
    
    func cancelWorkout() {
        activeWorkout = nil
    }
    
    func createCompetition(name: String, startDate: Date, endDate: Date, participants: [UUID]) {
        let competition = WorkoutCompetition(name: name, startDate: startDate, endDate: endDate, participants: participants)
        competitions.append(competition)
        saveCompetitions()
    }
    
    private func updateCompetitions(workout: Workout) {
        let now = Date()
        for index in competitions.indices {
            if competitions[index].startDate <= now && competitions[index].endDate >= now {
                if let entryIndex = competitions[index].leaderboard.firstIndex(where: { $0.userId == workout.userId }) {
                    competitions[index].leaderboard[entryIndex].totalSteps += workout.steps
                    competitions[index].leaderboard[entryIndex].totalCalories += workout.calories
                    competitions[index].leaderboard[entryIndex].totalWorkouts += 1
                } else {
                    // Create new entry
                    var entry = CompetitionEntry(userId: workout.userId, userName: "User") // Will be updated with actual name
                    entry.totalSteps = workout.steps
                    entry.totalCalories = workout.calories
                    entry.totalWorkouts = 1
                    competitions[index].leaderboard.append(entry)
                }
                
                // Sort and rank
                competitions[index].leaderboard.sort { $0.totalSteps > $1.totalSteps }
                for rankIndex in competitions[index].leaderboard.indices {
                    competitions[index].leaderboard[rankIndex].rank = rankIndex + 1
                }
            }
        }
        saveCompetitions()
    }
    
    private func loadWorkoutHistory() {
        if let data = UserDefaults.standard.data(forKey: "workoutHistory"),
           let decoded = try? JSONDecoder().decode([Workout].self, from: data) {
            workoutHistory = decoded
        }
    }
    
    private func saveWorkoutHistory() {
        if let encoded = try? JSONEncoder().encode(workoutHistory) {
            UserDefaults.standard.set(encoded, forKey: "workoutHistory")
        }
    }
    
    private func loadCompetitions() {
        if let data = UserDefaults.standard.data(forKey: "workoutCompetitions"),
           let decoded = try? JSONDecoder().decode([WorkoutCompetition].self, from: data) {
            competitions = decoded
        }
    }
    
    private func saveCompetitions() {
        if let encoded = try? JSONEncoder().encode(competitions) {
            UserDefaults.standard.set(encoded, forKey: "workoutCompetitions")
        }
    }
}

