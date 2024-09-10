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
    @State private var isLoggedIn = false

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
                    
                    // to be added with supabase
                    Button(action: {
                        isLoggedIn.toggle()
                    }) {
                        Text(isLoggedIn ? "Log Out" : "Log In")
                            .foregroundColor(isLoggedIn ? .red : .blue)
                    }
                    
                    NavigationLink(destination: DeleteAllDataView()) {
                        Text("Delete All Data")
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

struct DeleteAllDataView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var isDeleted = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Delete All Data")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Are you sure you want to delete all data?")
                .font(.body)

            Button(action: {
                deleteAllData()
            }) {
                Text("Delete All Data")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(10)
            }
            .alert(isPresented: $isDeleted) {
                Alert(title: Text("Data Deleted"),
                      message: Text("All data has been successfully deleted."),
                      dismissButton: .default(Text("OK")) {
                          presentationMode.wrappedValue.dismiss()
                      })
            }
        }
        .padding()
    }

    private func deleteAllData() {
        // Clear all data from UserDefaults
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()
        
        isDeleted = true
    }
}

#Preview {
    SettingsView()
}
