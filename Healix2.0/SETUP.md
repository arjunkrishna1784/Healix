# MedBot Setup Instructions

## Required Xcode Configuration

### 1. Enable HealthKit Capability

1. Open `Healix2.0.xcodeproj` in Xcode
2. Select the project in the navigator
3. Select the target "Healix2.0"
4. Go to the "Signing & Capabilities" tab
5. Click "+ Capability"
6. Add "HealthKit"
7. Ensure "HealthKit" is checked in the capabilities list

### 2. Add HealthKit Usage Description

1. In the same target settings, go to the "Info" tab
2. Add a new key: `NSHealthShareUsageDescription`
3. Set the value to: "MedBot needs access to your health data to display your daily activity metrics like step count and active calories."

### 3. Update Minimum iOS Version

Ensure the minimum iOS deployment target is set to iOS 17.0 or later (as specified in requirements).

### 4. Build and Run

The app should now build successfully. On first launch:
- The disclaimer modal will appear
- HealthKit permissions will be requested when the user taps "Enable HealthKit" on the Dashboard

## Project Structure

```
MedBot/
├── MedBotApp.swift          # App entry point
├── ContentView.swift        # Main TabView navigation
├── Views/
│   ├── DashboardView.swift  # Main dashboard
│   ├── HealthScoreCard.swift
│   ├── ActivityCard.swift
│   ├── InsightCard.swift
│   ├── ChatView.swift       # AI Assistant
│   ├── NewsView.swift       # Health news feed
│   └── DisclaimerView.swift # First launch disclaimer
├── Models/
│   └── ChatMessage.swift
├── Services/
│   ├── HealthKitManager.swift
│   ├── OpenAIService.swift  # Mock responses (Phase 1)
│   └── NewsService.swift    # Mock news (Phase 1)
└── Utils/
    └── Constants.swift      # App constants & disclaimer text
```

## Features Implemented

✅ Dashboard with Health Score, Activity, and Daily Insights
✅ HealthKit integration (steps & active calories)
✅ AI Chat Assistant with educational responses
✅ Medical News Feed
✅ Legal disclaimers (first launch, chat banner)
✅ Dark mode support (automatic via SwiftUI)
✅ Clean, Apple-style UI

## Next Steps (Phase 2)

- Replace mock AI responses with real OpenAI API integration
- Replace mock news with real health news API
- Add more sophisticated health score calculation
- Add Apple Watch support
- Add haptic feedback

