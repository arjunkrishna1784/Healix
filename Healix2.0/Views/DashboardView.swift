//
//  DashboardView.swift
//  MedBot
//
//  Created by Arjun Krishnamurthy on 12/16/25.
//

import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var healthKitManager: HealthKitManager
    @State private var healthScore: Int = 75
    @State private var dailyInsight: String = "Getting 7-9 hours of quality sleep can significantly improve your overall health and well-being."
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Gradient Background
                Color.healixLightGradient()
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Health Score Card
                        HealthScoreCard(score: healthScore)
                            .transition(.scale.combined(with: .opacity))
                        
                        // Activity Card
                        ActivityCard(
                            stepCount: healthKitManager.stepCount,
                            activeCalories: healthKitManager.activeCalories,
                            isAuthorized: healthKitManager.isAuthorized,
                            onRequestAuthorization: {
                                Task {
                                    await healthKitManager.requestAuthorization()
                                }
                            }
                        )
                        .transition(.scale.combined(with: .opacity))
                        
                        // Sleep Card
                        SleepCard(
                            sleepHours: healthKitManager.sleepHours,
                            isAuthorized: healthKitManager.isAuthorized,
                            onRequestAuthorization: {
                                Task {
                                    await healthKitManager.requestAuthorization()
                                }
                            }
                        )
                        .transition(.scale.combined(with: .opacity))
                        
                        // Heart Rate Card
                        HeartRateCard(
                            heartRate: healthKitManager.heartRate,
                            isAuthorized: healthKitManager.isAuthorized,
                            onRequestAuthorization: {
                                Task {
                                    await healthKitManager.requestAuthorization()
                                }
                            }
                        )
                        .transition(.scale.combined(with: .opacity))
                        
                        // Charts Section
                        if !healthKitManager.weeklySteps.isEmpty {
                            StepChartView(data: healthKitManager.weeklySteps)
                                .transition(.move(edge: .bottom).combined(with: .opacity))
                        }
                        
                        if !healthKitManager.weeklyCalories.isEmpty {
                            CalorieChartView(data: healthKitManager.weeklyCalories)
                                .transition(.move(edge: .bottom).combined(with: .opacity))
                        }
                        
                        // Daily Insight Card
                        InsightCard(insight: dailyInsight)
                            .transition(.scale.combined(with: .opacity))
                    }
                    .padding()
                }
            }
            .navigationTitle("Dashboard")
            .refreshable {
                await refreshData()
            }
            .task {
                await refreshData()
            }
        }
    }
    
    private func refreshData() async {
        // Refresh HealthKit data
        if healthKitManager.isAuthorized {
            await healthKitManager.fetchTodayData()
        }
        
        // Calculate health score (placeholder logic)
        // In future, this could be based on multiple factors
        let stepsScore = min(Int(healthKitManager.stepCount / 100), 40) // Max 40 points
        let caloriesScore = min(Int(healthKitManager.activeCalories / 10), 30) // Max 30 points
        let baseScore = 30 // Base score
        
        healthScore = min(stepsScore + caloriesScore + baseScore, 100)
        
        // Generate daily insight (mock for now)
        let insights = [
            "Getting 7-9 hours of quality sleep can significantly improve your overall health and well-being.",
            "Regular physical activity, even 30 minutes a day, can boost your mood and energy levels.",
            "Staying hydrated throughout the day helps maintain optimal cognitive function.",
            "Taking breaks from screens every hour can reduce eye strain and improve focus.",
            "A balanced diet rich in fruits and vegetables supports long-term health."
        ]
        dailyInsight = insights.randomElement() ?? insights[0]
    }
}

#Preview {
    DashboardView()
        .environmentObject(HealthKitManager())
}

