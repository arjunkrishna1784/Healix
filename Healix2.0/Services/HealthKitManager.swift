//
//  HealthKitManager.swift
//  MedBot
//
//  Created by Arjun Krishnamurthy on 12/16/25.
//

import Foundation
import HealthKit
import Combine

class HealthKitManager: ObservableObject {
    private let healthStore = HKHealthStore()
    
    @Published var stepCount: Double = 0
    @Published var activeCalories: Double = 0
    @Published var heartRate: Double = 0
    @Published var sleepHours: Double = 0
    @Published var isAuthorized: Bool = false
    @Published var weeklySteps: [DailyMetric] = []
    @Published var weeklyCalories: [DailyMetric] = []
    
    init() {
        checkAuthorizationStatus()
    }
    
    // Check if HealthKit is available on this device
    func isHealthKitAvailable() -> Bool {
        return HKHealthStore.isHealthDataAvailable()
    }
    
    // Request HealthKit authorization
    func requestAuthorization() async {
        guard isHealthKitAvailable() else {
            print("HealthKit is not available on this device")
            return
        }
        
        guard let stepCountType = HKQuantityType.quantityType(forIdentifier: .stepCount),
              let activeEnergyType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned),
              let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate),
              let sleepType = HKCategoryType.categoryType(forIdentifier: .sleepAnalysis) else {
            return
        }
        
        let typesToRead: Set<HKObjectType> = [stepCountType, activeEnergyType, heartRateType, sleepType]
        
        do {
            try await healthStore.requestAuthorization(
                toShare: Set<HKSampleType>(),
                read: typesToRead
            )
            await MainActor.run {
                checkAuthorizationStatus()
            }
            await fetchTodayData()
        } catch {
            print("HealthKit authorization error: \(error.localizedDescription)")
        }
    }
    
    // Check current authorization status
    private func checkAuthorizationStatus() {
        guard isHealthKitAvailable(),
              let stepCountType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            isAuthorized = false
            return
        }
        
        let status = healthStore.authorizationStatus(for: stepCountType)
        // For read-only access, we check if authorization has been granted
        isAuthorized = (status == .sharingAuthorized)
    }
    
    // Fetch today's step count and active calories
    func fetchTodayData() async {
        guard isHealthKitAvailable() else { return }
        
        let calendar = Calendar.current
        let now = Date()
        let startOfDay = calendar.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        // Fetch step count
        if let stepCountType = HKQuantityType.quantityType(forIdentifier: .stepCount) {
            let stepQuery = HKStatisticsQuery(
                quantityType: stepCountType,
                quantitySamplePredicate: predicate,
                options: .cumulativeSum
            ) { [weak self] _, result, error in
                guard let self = self, let result = result, error == nil else { return }
                
                let steps = result.sumQuantity()?.doubleValue(for: HKUnit.count()) ?? 0
                Task { @MainActor in
                    self.stepCount = steps
                }
            }
            healthStore.execute(stepQuery)
        }
        
        // Fetch active calories
        if let activeEnergyType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned) {
            let calorieQuery = HKStatisticsQuery(
                quantityType: activeEnergyType,
                quantitySamplePredicate: predicate,
                options: .cumulativeSum
            ) { [weak self] _, result, error in
                guard let self = self, let result = result, error == nil else { return }
                
                let calories = result.sumQuantity()?.doubleValue(for: HKUnit.kilocalorie()) ?? 0
                Task { @MainActor in
                    self.activeCalories = calories
                }
            }
            healthStore.execute(calorieQuery)
        }
        
        // Fetch heart rate (most recent)
        if let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate) {
            let heartRateQuery = HKSampleQuery(
                sampleType: heartRateType,
                predicate: HKQuery.predicateForSamples(withStart: calendar.date(byAdding: .day, value: -1, to: now) ?? startOfDay, end: now, options: []),
                limit: 1,
                sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)]
            ) { [weak self] _, samples, error in
                guard let self = self, let sample = samples?.first as? HKQuantitySample, error == nil else { return }
                
                let heartRate = sample.quantity.doubleValue(for: HKUnit.count().unitDivided(by: HKUnit.minute()))
                Task { @MainActor in
                    self.heartRate = heartRate
                }
            }
            healthStore.execute(heartRateQuery)
        }
        
        // Fetch sleep data (last night)
        if let sleepType = HKCategoryType.categoryType(forIdentifier: .sleepAnalysis) {
            let yesterday = calendar.date(byAdding: .day, value: -1, to: now) ?? now
            let yesterdayStart = calendar.startOfDay(for: yesterday)
            let todayStart = calendar.startOfDay(for: now)
            
            let sleepQuery = HKSampleQuery(
                sampleType: sleepType,
                predicate: HKQuery.predicateForSamples(withStart: yesterdayStart, end: todayStart, options: []),
                limit: HKObjectQueryNoLimit,
                sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)]
            ) { [weak self] _, samples, error in
                guard let self = self, let samples = samples, error == nil else { return }
                
                // Calculate total sleep time
                var totalSleep: TimeInterval = 0
                for sample in samples {
                    if let categorySample = sample as? HKCategorySample {
                        // Only count actual sleep (not in bed time)
                        if categorySample.value == HKCategoryValueSleepAnalysis.asleep.rawValue ||
                           categorySample.value == HKCategoryValueSleepAnalysis.asleepDeep.rawValue ||
                           categorySample.value == HKCategoryValueSleepAnalysis.asleepREM.rawValue ||
                           categorySample.value == HKCategoryValueSleepAnalysis.asleepCore.rawValue {
                            totalSleep += sample.endDate.timeIntervalSince(sample.startDate)
                        }
                    }
                }
                
                let sleepHours = totalSleep / 3600.0
                Task { @MainActor in
                    self.sleepHours = sleepHours
                }
            }
            healthStore.execute(sleepQuery)
        }
        
        // Fetch weekly data for charts
        await fetchWeeklyData()
    }
    
    // Fetch weekly data for charts
    func fetchWeeklyData() async {
        guard isHealthKitAvailable() else { return }
        
        let calendar = Calendar.current
        let now = Date()
        
        // Use actor to safely collect results from concurrent queries
        actor DataCollector {
            var weeklySteps: [DailyMetric] = []
            var weeklyCalories: [DailyMetric] = []
            
            func addSteps(_ metric: DailyMetric) {
                weeklySteps.append(metric)
            }
            
            func addCalories(_ metric: DailyMetric) {
                weeklyCalories.append(metric)
            }
            
            func getResults() -> (steps: [DailyMetric], calories: [DailyMetric]) {
                return (
                    steps: weeklySteps.sorted { $0.date < $1.date },
                    calories: weeklyCalories.sorted { $0.date < $1.date }
                )
            }
        }
        
        let collector = DataCollector()
        
        // Generate last 7 days
        for dayOffset in 0..<7 {
            guard let date = calendar.date(byAdding: .day, value: -dayOffset, to: now) else { continue }
            let startOfDay = calendar.startOfDay(for: date)
            let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) ?? date
            let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: endOfDay, options: .strictStartDate)
            
            // Fetch steps for this day
            if let stepCountType = HKQuantityType.quantityType(forIdentifier: .stepCount) {
                let stepQuery = HKStatisticsQuery(
                    quantityType: stepCountType,
                    quantitySamplePredicate: predicate,
                    options: .cumulativeSum
                ) { _, result, error in
                    guard let result = result, error == nil else { return }
                    let steps = result.sumQuantity()?.doubleValue(for: HKUnit.count()) ?? 0
                    Task {
                        await collector.addSteps(DailyMetric(date: startOfDay, value: steps))
                    }
                }
                healthStore.execute(stepQuery)
            }
            
            // Fetch calories for this day
            if let activeEnergyType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned) {
                let calorieQuery = HKStatisticsQuery(
                    quantityType: activeEnergyType,
                    quantitySamplePredicate: predicate,
                    options: .cumulativeSum
                ) { _, result, error in
                    guard let result = result, error == nil else { return }
                    let calories = result.sumQuantity()?.doubleValue(for: HKUnit.kilocalorie()) ?? 0
                    Task {
                        await collector.addCalories(DailyMetric(date: startOfDay, value: calories))
                    }
                }
                healthStore.execute(calorieQuery)
            }
        }
        
        // Wait a bit for queries to complete, then update
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        
        let results = await collector.getResults()
        
        await MainActor.run {
            self.weeklySteps = results.steps
            self.weeklyCalories = results.calories
        }
    }
}

