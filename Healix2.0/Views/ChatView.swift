//
//  ChatView.swift
//  MedBot
//
//  Created by Arjun Krishnamurthy on 12/16/25.
//

import SwiftUI

struct ChatView: View {
    @State private var messages: [ChatMessage] = []
    @State private var inputText: String = ""
    @State private var isLoading: Bool = false
    @FocusState private var isInputFocused: Bool
    @State private var selectedTab: ChatTab = .chat
    @StateObject private var healthHistory = HealthIssueHistory.shared
    
    enum ChatTab {
        case chat
        case history
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Tab Picker
                Picker("View", selection: $selectedTab) {
                    Text("Chat").tag(ChatTab.chat)
                    Text("History").tag(ChatTab.history)
                }
                .pickerStyle(.segmented)
                .padding()
                
                if selectedTab == .chat {
                    chatView
                } else {
                    historyView
                }
            }
            .navigationTitle("AI Health Assistant")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    private var chatView: some View {
        VStack(spacing: 0) {
            // Disclaimer Banner
            DisclaimerBanner()
            
            // Chat Messages
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 12) {
                        if messages.isEmpty {
                            VStack(spacing: 16) {
                                Image(systemName: "message.circle.fill")
                                    .font(.system(size: 60))
                                    .foregroundColor(.yellow.opacity(0.3))
                                
                                Text("Ask me about health topics")
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                                
                                Text("I can provide educational information about symptoms and health concerns. Remember, I don't provide diagnoses.")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.top, 60)
                        }
                        
                        ForEach(messages) { message in
                            ChatBubble(message: message)
                                .id(message.id)
                        }
                        
                        if isLoading {
                            HStack {
                                ProgressView()
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                Text("Thinking...")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            .background(Color(.systemGray5))
                            .cornerRadius(20)
                            .padding(.leading, 16)
                        }
                    }
                    .padding()
                }
                .onChange(of: messages.count) { _ in
                    if let lastMessage = messages.last {
                        withAnimation {
                            proxy.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
            }
            
            // Input Area
            HStack(spacing: 12) {
                TextField("Describe your symptoms or ask a question...", text: $inputText, axis: .vertical)
                    .textFieldStyle(.plain)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color(.systemGray6))
                    .cornerRadius(20)
                    .focused($isInputFocused)
                    .lineLimit(1...4)
                    .disabled(isLoading)
                
                Button(action: sendMessage) {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 32))
                        .foregroundColor(inputText.isEmpty || isLoading ? .gray : .yellow)
                }
                .disabled(inputText.isEmpty || isLoading)
            }
            .padding()
            .background(Color(.systemBackground))
        }
    }
    
    private var historyView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                if healthHistory.issues.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "clock.arrow.circlepath")
                            .font(.system(size: 60))
                            .foregroundColor(.yellow.opacity(0.3))
                        Text("No Health Issues Recorded")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Text("Your past health consultations will appear here")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 100)
                } else {
                    ForEach(healthHistory.issues) { issue in
                        HealthIssueCard(issue: issue)
                    }
                }
            }
            .padding()
        }
    }
    
    private func sendMessage() {
        guard !inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let userMessage = ChatMessage(content: inputText, isUser: true)
        messages.append(userMessage)
        
        let messageToSend = inputText
        inputText = ""
        isInputFocused = false
        isLoading = true
        
        Task {
            // Get AI response with diagnosis insight
            let response = await OpenAIService.shared.getDiagnosisResponse(for: messageToSend)
            
            await MainActor.run {
                let aiMessage = ChatMessage(content: response.content, isUser: false, diagnosisInsight: response.diagnosisInsight)
                messages.append(aiMessage)
                isLoading = false
                
                // Save to history
                let healthIssue = HealthIssue(
                    userMessage: messageToSend,
                    aiResponse: response.content,
                    diagnosisInsight: response.diagnosisInsight
                )
                healthHistory.addIssue(healthIssue)
            }
        }
    }
}

struct ChatBubble: View {
    let message: ChatMessage
    
    var body: some View {
        HStack {
            if message.isUser {
                Spacer(minLength: 50)
            }
            
            VStack(alignment: message.isUser ? .trailing : .leading, spacing: 8) {
                // Diagnosis Insight Card (if available)
                if let insight = message.diagnosisInsight, !message.isUser {
                    DiagnosisCard(insight: insight)
                        .padding(.bottom, 4)
                }
                
                Text(message.content)
                    .font(.body)
                    .foregroundColor(message.isUser ? .white : .primary)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(
                        Group {
                            if message.isUser {
                                LinearGradient(
                                    colors: [Color.yellow.opacity(0.8), Color.orange.opacity(0.8)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            } else {
                                LinearGradient(
                                    colors: [Color(.systemGray5), Color(.systemGray6)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            }
                        }
                    )
                    .cornerRadius(20)
                    .shadow(color: message.isUser ? .yellow.opacity(0.3) : .clear, radius: 5)
                
                Text(message.timestamp, style: .time)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 4)
            }
            
            if !message.isUser {
                Spacer(minLength: 50)
            }
        }
        .transition(.scale.combined(with: .opacity))
    }
}

struct DiagnosisCard: View {
    let insight: DiagnosisInsight
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(insight.condition)
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    Text("Confidence: \(insight.confidence)%")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Confidence Circle
                ZStack {
                    Circle()
                        .stroke(severityColor.opacity(0.3), lineWidth: 8)
                        .frame(width: 60, height: 60)
                    
                    Circle()
                        .trim(from: 0, to: CGFloat(insight.confidence) / 100)
                        .stroke(severityColor, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                        .frame(width: 60, height: 60)
                        .rotationEffect(.degrees(-90))
                        .animation(.spring(response: 1.0), value: insight.confidence)
                    
                    Text("\(insight.confidence)%")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(severityColor)
                }
            }
            
            Text(insight.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Divider()
            
            Text("Recommendations:")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
            
            ForEach(insight.recommendations, id: \.self) { recommendation in
                HStack(alignment: .top, spacing: 8) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(severityColor)
                        .font(.caption)
                    Text(recommendation)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        colors: [severityColor.opacity(0.1), severityColor.opacity(0.05)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(severityColor.opacity(0.3), lineWidth: 2)
        )
    }
    
    private var severityColor: Color {
        switch insight.severity {
        case .mild: return .green
        case .moderate: return .orange
        case .severe: return .red
        }
    }
}

struct DisclaimerBanner: View {
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.caption)
            Text(Constants.medicalDisclaimer)
                .font(.caption)
        }
        .foregroundColor(.orange)
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity)
        .background(Color.orange.opacity(0.1))
    }
}

#Preview {
    ChatView()
}

