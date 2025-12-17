//
//  SettingsView.swift
//  MedBot
//
//  Created by Arjun Krishnamurthy on 12/16/25.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var authService: AuthService
    @EnvironmentObject var settings: AppSettings
    @State private var showImagePicker = false
    @State private var showLogoutAlert = false
    
    var body: some View {
        NavigationStack {
            List {
                // Profile Section
                Section("Profile") {
                    HStack(spacing: 16) {
                        if let imageData = settings.profileImageData,
                           let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 80, height: 80)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.blue, lineWidth: 3))
                        } else {
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [.blue, .purple],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 80, height: 80)
                                
                                if let user = authService.currentUser {
                                    Text(user.name.prefix(1).uppercased())
                                        .font(.system(size: 36, weight: .bold))
                                        .foregroundColor(.white)
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            if let user = authService.currentUser {
                                Text(user.name)
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                Text(user.email)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        Spacer()
                    }
                    .padding(.vertical, 8)
                    
                    Button(action: { showImagePicker = true }) {
                        Label("Change Profile Picture", systemImage: "camera.fill")
                    }
                }
                
                // Privacy Section
                Section("Privacy") {
                    Toggle(isOn: $settings.hideMetricsFromFriends) {
                        Label("Hide Metrics from Friends", systemImage: "eye.slash.fill")
                    }
                    .onChange(of: settings.hideMetricsFromFriends) { _ in
                        settings.saveSettings()
                    }
                    
                    Text("When enabled, your health metrics will not be visible to your friends in competitions and profiles.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                // Appearance Section
                Section("Appearance") {
                    Picker("Theme", selection: $settings.selectedTheme) {
                        ForEach(AppTheme.allCases, id: \.self) { theme in
                            HStack {
                                Text(theme.rawValue)
                                if theme != .system {
                                    Circle()
                                        .fill(theme.primaryColor)
                                        .frame(width: 20, height: 20)
                                }
                            }
                            .tag(theme)
                        }
                    }
                    .onChange(of: settings.selectedTheme) { _ in
                        settings.saveSettings()
                    }
                }
                
                // Account Section
                Section("Account") {
                    Button(role: .destructive, action: { showLogoutAlert = true }) {
                        Label("Sign Out", systemImage: "arrow.right.square")
                    }
                }
            }
            .navigationTitle("Settings")
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(imageData: $settings.profileImageData) { data in
                    settings.profileImageData = data
                    settings.saveSettings()
                }
            }
            .alert("Sign Out", isPresented: $showLogoutAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Sign Out", role: .destructive) {
                    authService.signOut()
                }
            } message: {
                Text("Are you sure you want to sign out?")
            }
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var imageData: Data?
    let onImageSelected: (Data?) -> Void
    @Environment(\.dismiss) var dismiss
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let editedImage = info[.editedImage] as? UIImage,
               let imageData = editedImage.jpegData(compressionQuality: 0.8) {
                parent.imageData = imageData
                parent.onImageSelected(imageData)
            } else if let originalImage = info[.originalImage] as? UIImage,
                      let imageData = originalImage.jpegData(compressionQuality: 0.8) {
                parent.imageData = imageData
                parent.onImageSelected(imageData)
            }
            parent.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(AuthService.shared)
        .environmentObject(AppSettings.shared)
}

