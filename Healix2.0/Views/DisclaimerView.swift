//
//  DisclaimerView.swift
//  MedBot
//
//  Created by Arjun Krishnamurthy on 12/16/25.
//

import SwiftUI

struct DisclaimerView: View {
    @Binding var hasSeenDisclaimer: Bool
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Warning Icon
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.orange)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 40)
                    
                    // Title
                    Text("Important Medical Disclaimer")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                    
                    // Disclaimer Text
                    VStack(alignment: .leading, spacing: 16) {
                        Text(Constants.medicalDisclaimer)
                            .font(.body)
                            .foregroundColor(.primary)
                        
                        Divider()
                        
                        Text("What Healix Does:")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Text("• Provides educational health information")
                            .font(.body)
                        Text("• Offers general health insights")
                            .font(.body)
                        Text("• Helps you understand health topics")
                            .font(.body)
                        
                        Divider()
                        
                        Text("What Healix Does NOT Do:")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Text("• Provide medical diagnoses")
                            .font(.body)
                        Text("• Offer treatment plans")
                            .font(.body)
                        Text("• Replace professional medical advice")
                            .font(.body)
                        
                        Divider()
                        
                        Text("Always consult a licensed healthcare professional for medical concerns, diagnoses, and treatment.")
                            .font(.body)
                            .fontWeight(.medium)
                            .foregroundColor(.red)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                }
                .padding()
            }
            .navigationTitle("Welcome to Healix")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("I Understand") {
                        hasSeenDisclaimer = true
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
            .interactiveDismissDisabled()
        }
    }
}

#Preview {
    DisclaimerView(hasSeenDisclaimer: .constant(false))
}

