//
//  Constants.swift
//  MedBot
//
//  Created by Arjun Krishnamurthy on 12/16/25.
//

import Foundation

struct Constants {
    // Legal Disclaimer Text
    static let medicalDisclaimer = "This app provides educational information only and is not a medical diagnosis. Always consult a licensed healthcare professional."
    
    // App Information
    static let appName = "Healix"
    
    // HealthKit Types
    static let healthKitReadTypes: Set<String> = [
        "HKQuantityTypeIdentifierStepCount",
        "HKQuantityTypeIdentifierActiveEnergyBurned"
    ]
}

