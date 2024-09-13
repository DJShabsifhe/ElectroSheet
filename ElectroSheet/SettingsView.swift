//
//  SettingsView.swift
//  ElectroSheet
//
//  Created by DJShabsifhe on 2024/9/7.
//

import SwiftUI
import UIKit
import Foundation

struct SettingsView: View {
    @State private var autoSync = true
    @State private var selectedSort = "Date"
    @State private var selectedLanguage = "English"
    @State private var showingShareSheet = false
    @State private var fileURL: URL?

    func exportUserDefaultsToJSON() -> URL? {
        let userDefaults = UserDefaults.standard
        let dictionary = userDefaults.dictionaryRepresentation()

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
            let fileName = "UserDefaultsExport.json"
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileURL = documentsDirectory.appendingPathComponent(fileName)

            try jsonData.write(to: fileURL)
            return fileURL
        } catch {
            print("Error exporting UserDefaults: \(error)")
            return nil
        }
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("General")) {
                    Toggle("Auto Sync with iCloud", isOn: $autoSync)

                    NavigationLink(destination: ImportDataView(viewModel: PartViewModel())) {
                        Text("Import Data from JSON")
                            .foregroundColor(.blue)
                    }
                    
                    Button("Export UserDefaults to JSON") {
                        if let url = exportUserDefaultsToJSON() {
                            fileURL = url
                            showingShareSheet = true // Trigger the share sheet
                        }
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
            .sheet(isPresented: $showingShareSheet) {
                if let fileURL = fileURL {
                    ShareSheet(items: [fileURL])
                }
            }
        }
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    var items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview {
    SettingsView()
}
