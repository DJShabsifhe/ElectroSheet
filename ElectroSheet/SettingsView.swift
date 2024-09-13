//
//  SettingsView.swift
//  ElectroSheet
//
//  Created by DJShabsifhe on 2024/9/7.
//

import SwiftUI

struct SettingsView: View {
    @State private var autoSync = true
    @State private var selectedSort = "Date"
    @State private var selectedLanguage = "English"

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("General")) {
                    Toggle("Auto Sync with iCloud", isOn: $autoSync)

                    NavigationLink(destination: ImportDataView(viewModel: PartViewModel())) {
                        Text("Import Data from JSON")
                            .foregroundColor(.blue)
                    }
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

            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
}
