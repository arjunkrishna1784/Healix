//
//  DiseaseDatabase.swift
//  Healix
//
//  Created by Arjun Krishnamurthy on 12/16/25.
//

import Foundation

class DiseaseDatabase {
    static let shared = DiseaseDatabase()
    
    private var diseases: [Disease] = []
    
    private init() {
        loadDiseases()
    }
    
    // Comprehensive disease database
    private func loadDiseases() {
        diseases = [
            // Respiratory
            Disease(
                name: "Common Cold",
                category: .respiratory,
                commonSymptoms: ["runny nose", "sneezing", "congestion", "sore throat", "cough", "mild headache"],
                severity: .mild,
                description: "A viral infection of the upper respiratory tract.",
                typicalDuration: "7-10 days",
                recommendations: ["Rest and hydration", "Over-the-counter cold medications", "Warm fluids", "Gargle with salt water"]
            ),
            Disease(
                name: "Influenza (Flu)",
                category: .respiratory,
                commonSymptoms: ["fever", "chills", "body aches", "fatigue", "cough", "sore throat", "headache"],
                rareSymptoms: ["nausea", "vomiting"],
                severity: .moderate,
                description: "A contagious respiratory illness caused by influenza viruses.",
                typicalDuration: "1-2 weeks",
                recommendations: ["Rest", "Stay hydrated", "Antiviral medications if prescribed", "Fever reducers"]
            ),
            Disease(
                name: "Pneumonia",
                category: .respiratory,
                commonSymptoms: ["cough", "fever", "chest pain", "shortness of breath", "fatigue", "sweating"],
                rareSymptoms: ["chills", "nausea"],
                severity: .severe,
                description: "Infection that inflames air sacs in one or both lungs.",
                typicalDuration: "1-3 weeks",
                recommendations: ["Seek immediate medical attention", "Antibiotics if bacterial", "Rest", "Stay hydrated"]
            ),
            Disease(
                name: "Bronchitis",
                category: .respiratory,
                commonSymptoms: ["persistent cough", "mucus production", "chest discomfort", "fatigue", "shortness of breath"],
                severity: .moderate,
                description: "Inflammation of the lining of bronchial tubes.",
                typicalDuration: "1-3 weeks",
                recommendations: ["Rest", "Stay hydrated", "Cough suppressants", "Avoid irritants"]
            ),
            Disease(
                name: "Asthma",
                category: .respiratory,
                commonSymptoms: ["wheezing", "shortness of breath", "chest tightness", "coughing", "difficulty breathing"],
                severity: .moderate,
                description: "Chronic condition affecting airways in the lungs.",
                typicalDuration: "Chronic condition",
                recommendations: ["Use inhaler as prescribed", "Avoid triggers", "Monitor symptoms", "Seek emergency care if severe"]
            ),
            
            // Cardiovascular
            Disease(
                name: "Hypertension (High Blood Pressure)",
                category: .cardiovascular,
                commonSymptoms: ["headache", "dizziness", "shortness of breath", "chest pain"],
                rareSymptoms: ["nosebleeds", "vision problems"],
                severity: .moderate,
                description: "Long-term medical condition with high blood pressure in arteries.",
                typicalDuration: "Chronic condition",
                recommendations: ["Monitor blood pressure", "Medication as prescribed", "Reduce sodium intake", "Regular exercise"]
            ),
            Disease(
                name: "Angina",
                category: .cardiovascular,
                commonSymptoms: ["chest pain", "chest pressure", "shortness of breath", "fatigue"],
                rareSymptoms: ["nausea", "sweating"],
                severity: .severe,
                description: "Chest pain caused by reduced blood flow to heart muscles.",
                typicalDuration: "Episodic",
                recommendations: ["Seek immediate medical attention", "Nitroglycerin if prescribed", "Rest", "Avoid triggers"]
            ),
            
            // Neurological
            Disease(
                name: "Migraine",
                category: .neurological,
                commonSymptoms: ["severe headache", "nausea", "sensitivity to light", "sensitivity to sound", "throbbing pain"],
                rareSymptoms: ["aura", "vision changes"],
                severity: .moderate,
                description: "A neurological condition characterized by intense headaches.",
                typicalDuration: "4-72 hours",
                recommendations: ["Rest in dark, quiet room", "Pain relievers", "Stay hydrated", "Avoid triggers"]
            ),
            Disease(
                name: "Tension Headache",
                category: .neurological,
                commonSymptoms: ["headache", "pressure around head", "neck pain", "shoulder tension"],
                severity: .mild,
                description: "Common headache characterized by pressure or tightness.",
                typicalDuration: "30 minutes to several hours",
                recommendations: ["Rest", "Over-the-counter pain relievers", "Relaxation techniques", "Massage"]
            ),
            Disease(
                name: "Concussion",
                category: .neurological,
                commonSymptoms: ["headache", "dizziness", "confusion", "nausea", "memory problems"],
                rareSymptoms: ["loss of consciousness", "vision problems"],
                severity: .severe,
                description: "Traumatic brain injury caused by a blow to the head.",
                typicalDuration: "Days to weeks",
                recommendations: ["Seek immediate medical attention", "Rest", "Avoid physical activity", "Monitor symptoms"]
            ),
            
            // Gastrointestinal
            Disease(
                name: "Gastroenteritis (Stomach Flu)",
                category: .gastrointestinal,
                commonSymptoms: ["nausea", "vomiting", "diarrhea", "stomach cramps", "fever"],
                severity: .moderate,
                description: "Inflammation of the stomach and intestines.",
                typicalDuration: "1-3 days",
                recommendations: ["Stay hydrated", "BRAT diet (bananas, rice, applesauce, toast)", "Rest", "Avoid dairy"]
            ),
            Disease(
                name: "Food Poisoning",
                category: .gastrointestinal,
                commonSymptoms: ["nausea", "vomiting", "diarrhea", "stomach cramps", "fever"],
                rareSymptoms: ["blood in stool"],
                severity: .moderate,
                description: "Illness caused by consuming contaminated food.",
                typicalDuration: "1-3 days",
                recommendations: ["Stay hydrated", "Rest", "Avoid solid foods initially", "Seek medical care if severe"]
            ),
            Disease(
                name: "Irritable Bowel Syndrome (IBS)",
                category: .gastrointestinal,
                commonSymptoms: ["abdominal pain", "bloating", "diarrhea", "constipation", "gas"],
                severity: .mild,
                description: "Chronic condition affecting the large intestine.",
                typicalDuration: "Chronic condition",
                recommendations: ["Dietary changes", "Stress management", "Fiber supplements", "Regular exercise"]
            ),
            
            // Musculoskeletal
            Disease(
                name: "Arthritis",
                category: .musculoskeletal,
                commonSymptoms: ["joint pain", "stiffness", "swelling", "reduced range of motion"],
                severity: .moderate,
                description: "Inflammation of one or more joints.",
                typicalDuration: "Chronic condition",
                recommendations: ["Anti-inflammatory medications", "Physical therapy", "Exercise", "Weight management"]
            ),
            Disease(
                name: "Fibromyalgia",
                category: .musculoskeletal,
                commonSymptoms: ["widespread pain", "fatigue", "sleep problems", "tender points", "cognitive issues"],
                severity: .moderate,
                description: "Chronic condition causing widespread pain and tenderness.",
                typicalDuration: "Chronic condition",
                recommendations: ["Pain management", "Exercise", "Stress reduction", "Sleep hygiene"]
            ),
            
            // Infectious
            Disease(
                name: "COVID-19",
                category: .infectious,
                commonSymptoms: ["fever", "cough", "shortness of breath", "fatigue", "loss of taste", "loss of smell"],
                rareSymptoms: ["nausea", "diarrhea"],
                severity: .moderate,
                description: "Respiratory illness caused by SARS-CoV-2 virus.",
                typicalDuration: "1-2 weeks",
                recommendations: ["Isolate", "Rest", "Stay hydrated", "Monitor symptoms", "Seek medical care if severe"]
            ),
            Disease(
                name: "Mononucleosis (Mono)",
                category: .infectious,
                commonSymptoms: ["fatigue", "sore throat", "fever", "swollen lymph nodes", "body aches"],
                rareSymptoms: ["spleen enlargement"],
                severity: .moderate,
                description: "Viral infection causing extreme fatigue and other symptoms.",
                typicalDuration: "2-4 weeks",
                recommendations: ["Rest", "Stay hydrated", "Avoid contact sports", "Pain relievers"]
            ),
            
            // Mental Health
            Disease(
                name: "Anxiety Disorder",
                category: .mental,
                commonSymptoms: ["worry", "restlessness", "fatigue", "difficulty concentrating", "irritability", "sleep problems"],
                severity: .moderate,
                description: "Mental health condition characterized by excessive worry.",
                typicalDuration: "Chronic condition",
                recommendations: ["Therapy", "Medication if prescribed", "Relaxation techniques", "Regular exercise"]
            ),
            Disease(
                name: "Depression",
                category: .mental,
                commonSymptoms: ["sadness", "loss of interest", "fatigue", "sleep changes", "appetite changes", "difficulty concentrating"],
                severity: .moderate,
                description: "Mental health disorder affecting mood and daily functioning.",
                typicalDuration: "Weeks to months",
                recommendations: ["Seek professional help", "Therapy", "Medication if prescribed", "Support groups"]
            ),
            
            // Dermatological
            Disease(
                name: "Eczema",
                category: .dermatological,
                commonSymptoms: ["itchy skin", "redness", "dry skin", "rash", "inflammation"],
                severity: .mild,
                description: "Chronic skin condition causing itchy, inflamed skin.",
                typicalDuration: "Chronic condition",
                recommendations: ["Moisturize regularly", "Avoid triggers", "Topical corticosteroids", "Gentle skincare"]
            ),
            Disease(
                name: "Psoriasis",
                category: .dermatological,
                commonSymptoms: ["red patches", "silver scales", "itchy skin", "dry skin", "thickened nails"],
                severity: .moderate,
                description: "Chronic autoimmune condition affecting the skin.",
                typicalDuration: "Chronic condition",
                recommendations: ["Topical treatments", "Phototherapy", "Systemic medications", "Moisturize"]
            ),
            
            // Endocrine
            Disease(
                name: "Diabetes Type 2",
                category: .endocrine,
                commonSymptoms: ["increased thirst", "frequent urination", "fatigue", "blurred vision", "slow healing"],
                rareSymptoms: ["numbness in hands/feet"],
                severity: .moderate,
                description: "Chronic condition affecting how the body processes blood sugar.",
                typicalDuration: "Chronic condition",
                recommendations: ["Blood sugar monitoring", "Medication as prescribed", "Dietary changes", "Regular exercise"]
            ),
            Disease(
                name: "Hypothyroidism",
                category: .endocrine,
                commonSymptoms: ["fatigue", "weight gain", "cold sensitivity", "dry skin", "hair loss", "depression"],
                severity: .moderate,
                description: "Underactive thyroid gland.",
                typicalDuration: "Chronic condition",
                recommendations: ["Thyroid hormone replacement", "Regular monitoring", "Balanced diet", "Exercise"]
            ),
            
            // Other common conditions
            Disease(
                name: "Urinary Tract Infection (UTI)",
                category: .other,
                commonSymptoms: ["frequent urination", "burning sensation", "cloudy urine", "pelvic pain"],
                rareSymptoms: ["fever", "blood in urine"],
                severity: .moderate,
                description: "Infection in any part of the urinary system.",
                typicalDuration: "3-7 days with treatment",
                recommendations: ["Antibiotics as prescribed", "Stay hydrated", "Cranberry juice", "Urinate frequently"]
            ),
            Disease(
                name: "Sinusitis",
                category: .respiratory,
                commonSymptoms: ["facial pain", "nasal congestion", "thick nasal discharge", "headache", "cough"],
                severity: .moderate,
                description: "Inflammation of the sinuses.",
                typicalDuration: "1-2 weeks",
                recommendations: ["Nasal irrigation", "Decongestants", "Warm compress", "Stay hydrated"]
            ),
            Disease(
                name: "Allergic Rhinitis (Hay Fever)",
                category: .respiratory,
                commonSymptoms: ["sneezing", "runny nose", "itchy eyes", "nasal congestion", "watery eyes"],
                severity: .mild,
                description: "Allergic reaction to airborne allergens.",
                typicalDuration: "Seasonal or chronic",
                recommendations: ["Avoid allergens", "Antihistamines", "Nasal sprays", "Allergy shots if severe"]
            ),
            
            // Additional common conditions
            Disease(
                name: "Strep Throat",
                category: .infectious,
                commonSymptoms: ["sore throat", "fever", "swollen lymph nodes", "difficulty swallowing", "white patches on tonsils"],
                rareSymptoms: ["headache", "nausea"],
                severity: .moderate,
                description: "Bacterial infection causing inflammation and pain in the throat.",
                typicalDuration: "3-7 days with treatment",
                recommendations: ["Antibiotics as prescribed", "Rest", "Warm salt water gargles", "Stay hydrated"]
            ),
            Disease(
                name: "Conjunctivitis (Pink Eye)",
                category: .dermatological,
                commonSymptoms: ["red eyes", "itchy eyes", "watery eyes", "eye discharge", "swollen eyelids"],
                severity: .mild,
                description: "Inflammation of the conjunctiva, the clear tissue covering the white part of the eye.",
                typicalDuration: "1-2 weeks",
                recommendations: ["Avoid touching eyes", "Warm compresses", "Antibiotic eye drops if bacterial", "Good hygiene"]
            ),
            Disease(
                name: "Appendicitis",
                category: .gastrointestinal,
                commonSymptoms: ["abdominal pain", "nausea", "vomiting", "fever", "loss of appetite"],
                rareSymptoms: ["pain in lower right abdomen"],
                severity: .severe,
                description: "Inflammation of the appendix requiring immediate medical attention.",
                typicalDuration: "Requires surgery",
                recommendations: ["Seek immediate emergency medical care", "Do not eat or drink", "Do not take pain medication before seeing doctor"]
            ),
            Disease(
                name: "Kidney Stones",
                category: .other,
                commonSymptoms: ["severe pain", "pain in side or back", "painful urination", "blood in urine", "nausea"],
                rareSymptoms: ["fever", "chills"],
                severity: .severe,
                description: "Hard deposits of minerals and salts that form in the kidneys.",
                typicalDuration: "Days to weeks",
                recommendations: ["Seek medical attention", "Stay hydrated", "Pain management", "Medical procedures if needed"]
            ),
            Disease(
                name: "Gout",
                category: .musculoskeletal,
                commonSymptoms: ["severe joint pain", "swelling", "redness", "tenderness", "warmth in joint"],
                severity: .moderate,
                description: "Form of arthritis characterized by sudden, severe attacks of pain and swelling.",
                typicalDuration: "3-10 days per attack",
                recommendations: ["Anti-inflammatory medications", "Rest affected joint", "Ice packs", "Elevate joint"]
            ),
            Disease(
                name: "Shingles",
                category: .infectious,
                commonSymptoms: ["pain", "burning sensation", "rash", "blisters", "itching"],
                rareSymptoms: ["fever", "headache", "fatigue"],
                severity: .moderate,
                description: "Viral infection causing a painful rash, usually on one side of the body.",
                typicalDuration: "2-4 weeks",
                recommendations: ["Antiviral medications", "Pain relievers", "Calamine lotion", "Cool compresses"]
            ),
            Disease(
                name: "Lyme Disease",
                category: .infectious,
                commonSymptoms: ["rash", "fever", "fatigue", "headache", "joint pain"],
                rareSymptoms: ["bull's eye rash", "muscle aches"],
                severity: .moderate,
                description: "Tick-borne illness caused by bacteria.",
                typicalDuration: "Weeks to months",
                recommendations: ["Antibiotics as prescribed", "Early treatment is important", "Monitor for complications"]
            ),
            Disease(
                name: "Chronic Fatigue Syndrome",
                category: .other,
                commonSymptoms: ["severe fatigue", "sleep problems", "memory problems", "muscle pain", "headaches"],
                severity: .moderate,
                description: "Complex disorder characterized by extreme fatigue that doesn't improve with rest.",
                typicalDuration: "Chronic condition",
                recommendations: ["Pacing activities", "Cognitive behavioral therapy", "Graded exercise therapy", "Sleep management"]
            ),
            Disease(
                name: "GERD (Gastroesophageal Reflux Disease)",
                category: .gastrointestinal,
                commonSymptoms: ["heartburn", "chest pain", "regurgitation", "difficulty swallowing", "chronic cough"],
                severity: .mild,
                description: "Chronic digestive disease where stomach acid flows back into the esophagus.",
                typicalDuration: "Chronic condition",
                recommendations: ["Dietary changes", "Elevate head while sleeping", "Antacids", "Avoid trigger foods"]
            ),
            Disease(
                name: "Osteoporosis",
                category: .musculoskeletal,
                commonSymptoms: ["bone fractures", "loss of height", "stooped posture", "back pain"],
                severity: .moderate,
                description: "Condition where bones become weak and brittle.",
                typicalDuration: "Chronic condition",
                recommendations: ["Calcium and vitamin D supplements", "Weight-bearing exercise", "Medications as prescribed", "Fall prevention"]
            )
        ]
    }
    
    // AI-powered symptom analysis
    func analyzeSymptoms(_ userInput: String) -> [DiseaseMatch] {
        let userSymptoms = extractSymptoms(from: userInput)
        
        var matches: [DiseaseMatch] = []
        
        for disease in diseases {
            let confidence = disease.calculateMatchScore(userSymptoms: userSymptoms)
            
            if confidence > 20 { // Only include matches above 20% confidence
                matches.append(DiseaseMatch(
                    disease: disease,
                    confidence: Int(confidence),
                    matchedSymptoms: findMatchedSymptoms(userSymptoms: userSymptoms, disease: disease)
                ))
            }
        }
        
        // Sort by confidence (highest first)
        matches.sort { $0.confidence > $1.confidence }
        
        // Apply AI model-like confidence adjustment
        return adjustConfidenceWithAIModel(matches: matches, userSymptoms: userSymptoms)
    }
    
    // Extract symptoms from user input using NLP-like techniques
    private func extractSymptoms(from input: String) -> [String] {
        let lowercased = input.lowercased()
        var symptoms: [String] = []
        
        // Common symptom keywords
        let symptomKeywords = [
            "headache", "fever", "cough", "sore throat", "nausea", "vomiting", "diarrhea",
            "fatigue", "pain", "ache", "dizziness", "shortness of breath", "chest pain",
            "stomach pain", "abdominal pain", "joint pain", "muscle pain", "back pain",
            "rash", "itchy", "sneezing", "runny nose", "congestion", "wheezing",
            "chills", "sweating", "loss of appetite", "weight loss", "weight gain",
            "blurred vision", "sensitivity to light", "sensitivity to sound", "confusion",
            "memory problems", "difficulty concentrating", "irritability", "anxiety",
            "depression", "sadness", "sleep problems", "insomnia", "frequent urination",
            "burning sensation", "swollen", "stiffness", "numbness", "tingling"
        ]
        
        for keyword in symptomKeywords {
            if lowercased.contains(keyword) {
                symptoms.append(keyword)
            }
        }
        
        // Also extract phrases
        let phrases = lowercased.components(separatedBy: CharacterSet(charactersIn: ",.?!;"))
        symptoms.append(contentsOf: phrases.filter { $0.count > 3 })
        
        return Array(Set(symptoms)) // Remove duplicates
    }
    
    // Find which symptoms matched
    private func findMatchedSymptoms(userSymptoms: [String], disease: Disease) -> [String] {
        let allSymptoms = disease.commonSymptoms + disease.rareSymptoms
        let userSymptomsLower = userSymptoms.map { $0.lowercased() }
        
        return allSymptoms.filter { symptom in
            let symptomLower = symptom.lowercased()
            return userSymptomsLower.contains { $0.contains(symptomLower) || symptomLower.contains($0) }
        }
    }
    
    // AI model-like confidence adjustment
    // Simulates more sophisticated AI analysis
    private func adjustConfidenceWithAIModel(matches: [DiseaseMatch], userSymptoms: [String]) -> [DiseaseMatch] {
        return matches.map { match in
            var adjustedConfidence = match.confidence
            
            // Boost confidence if multiple symptoms match
            if match.matchedSymptoms.count >= 3 {
                adjustedConfidence = min(100, adjustedConfidence + 10)
            }
            
            // Reduce confidence for rare diseases if symptoms are common
            if match.disease.severity == .mild && match.matchedSymptoms.count < 2 {
                adjustedConfidence = max(20, adjustedConfidence - 15)
            }
            
            // Boost confidence if severity matches symptom severity
            let hasSevereSymptoms = userSymptoms.contains { $0.contains("severe") || $0.contains("intense") || $0.contains("extreme") }
            if hasSevereSymptoms && match.disease.severity == .severe {
                adjustedConfidence = min(100, adjustedConfidence + 15)
            }
            
            // Reduce confidence if too many matches (likely too generic)
            if matches.count > 5 && adjustedConfidence < 50 {
                adjustedConfidence = max(20, adjustedConfidence - 10)
            }
            
            return DiseaseMatch(
                disease: match.disease,
                confidence: adjustedConfidence,
                matchedSymptoms: match.matchedSymptoms
            )
        }.sorted { $0.confidence > $1.confidence }
    }
}

struct DiseaseMatch {
    let disease: Disease
    let confidence: Int
    let matchedSymptoms: [String]
}

