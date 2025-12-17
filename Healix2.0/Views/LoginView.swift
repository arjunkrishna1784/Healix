//
//  LoginView.swift
//  MedBot
//
//  Created by Arjun Krishnamurthy on 12/16/25.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authService: AuthService
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var name: String = ""
    @State private var isSignUp: Bool = false
    @State private var isLoading: Bool = false
    @State private var errorMessage: String = ""
    
    var body: some View {
        ZStack {
            // Gradient Background
            LinearGradient(
                colors: [Color.yellow.opacity(0.6), Color.orange.opacity(0.6)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Spacer()
                
                // App Logo/Title
                VStack(spacing: 16) {
                    Image(systemName: "heart.circle.fill")
                        .font(.system(size: 80))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.pink, .red],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .shadow(color: .pink.opacity(0.3), radius: 20)
                    
                    Text("Healix")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(radius: 10)
                }
                .padding(.bottom, 40)
                
                // Form
                VStack(spacing: 20) {
                    if isSignUp {
                        TextField("Full Name", text: $name)
                            .textFieldStyle(CustomTextFieldStyle())
                    }
                    
                    TextField("Email", text: $email)
                        .textFieldStyle(CustomTextFieldStyle())
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    
                    SecureField("Password", text: $password)
                        .textFieldStyle(CustomTextFieldStyle())
                    
                    if !errorMessage.isEmpty {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                            .padding(.horizontal)
                    }
                    
                    Button(action: handleAuth) {
                        HStack {
                            if isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Text(isSignUp ? "Sign Up" : "Sign In")
                                    .fontWeight(.semibold)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                    .background(
                        LinearGradient(
                            colors: [.yellow, .orange],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                        .foregroundColor(.white)
                        .cornerRadius(15)
                        .shadow(color: .blue.opacity(0.3), radius: 10)
                    }
                    .disabled(isLoading || email.isEmpty || password.isEmpty || (isSignUp && name.isEmpty))
                    
                    Button(action: { isSignUp.toggle() }) {
                        Text(isSignUp ? "Already have an account? Sign In" : "Don't have an account? Sign Up")
                            .foregroundColor(.white)
                            .font(.subheadline)
                    }
                }
                .padding(.horizontal, 30)
                
                Spacer()
            }
        }
    }
    
    private func handleAuth() {
        isLoading = true
        errorMessage = ""
        
        Task {
            let success: Bool
            if isSignUp {
                success = await authService.signUp(email: email, password: password, name: name)
            } else {
                success = await authService.signIn(email: email, password: password)
            }
            
            await MainActor.run {
                isLoading = false
                if !success {
                    errorMessage = "Authentication failed. Please try again."
                }
            }
        }
    }
}

struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(Color.white.opacity(0.9))
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.1), radius: 5)
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthService.shared)
}

