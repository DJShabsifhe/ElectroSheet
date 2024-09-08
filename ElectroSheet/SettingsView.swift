//
//  SettingsView.swift
//  ElectroSheet
//
//  Created by DJShabsifhe on 2024/9/7.
//

import SwiftUI

struct SettingsView: View {
    @State private var notificationsEnabled = true
    @State private var selectedSort = "Date"
    @State private var selectedLanguage = "English"
    @State private var isLoggedIn = false // Track login status

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("General")) {
                    Toggle("Enable Notifications", isOn: $notificationsEnabled)
                }

                Section(header: Text("Language")) {
                    Picker("Select Language", selection: $selectedLanguage) {
                        ForEach(["English", "Spanish", "French", "German"], id: \.self) { language in
                            Text(language)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                
                Section(header: Text("Favorite")) {
                    Picker("Sort By", selection: $selectedSort) {
                        ForEach(["Date", "Name", "Description"], id: \.self) { sort in
                            Text(sort)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                
                Section(header: Text("My Account")) {
                    NavigationLink(destination: Text("Change Password")) {
                        Text("Change Password")
                    }
                    
                    NavigationLink(destination: Text("On Build")) {
                        Text(isLoggedIn ? "Log Out" : "Log In") // Change text based on login status
                            .foregroundColor(isLoggedIn ? .red : .blue)
                    }
                    
                    NavigationLink(destination: Text("Delete All Data")) {
                        Text("Delete All Data")
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
}
