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
    @State private var showingImportSuccessAlert = false
    @State private var showingExportSuccessAlert = false
    @State private var showingDocumentPicker = false
    @ObservedObject var partViewModel = PartViewModel()

    func exportUserDefaultsToJSON() -> URL? {
        // Skip export to prevent crash
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
            print("Skipping export during preview")
            return nil
        }
        
        let userDefaults = UserDefaults.standard
        let dictionary = userDefaults.dictionaryRepresentation()

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
            let fileName = "UserDefaultsExport.json"
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileURL = documentsDirectory.appendingPathComponent(fileName)

            try jsonData.write(to: fileURL)
            showingExportSuccessAlert = true
            return fileURL
        } catch {
            print("Error exporting UserDefaults: \(error)")
            return nil
        }
    }

    func importPartsFromJSON(url: URL) {
        do {
            let data = try Data(contentsOf: url)
            let decodedParts = try JSONDecoder().decode([PartItem].self, from: data)
            partViewModel.parts = decodedParts
            showingImportSuccessAlert = true
        } catch {
            print("Error importing parts from JSON: \(error)")
        }
    }

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("General").font(.headline).foregroundColor(.primary)) {
                    NavigationLink(destination: ImportDataView(viewModel: PartViewModel())) {
                        Label("Import Data from JSON", systemImage: "square.and.arrow.down")
                            .font(.body)
                            .foregroundColor(.blue)
                    }
                    
                    Button(action: {
                        if let url = exportUserDefaultsToJSON() {
                            fileURL = url
                            showingShareSheet = true
                        }
                    }) {
                        Label("Export UserDefaults to JSON", systemImage: "square.and.arrow.up")
                            .font(.body)
                            .foregroundColor(.blue)
                    }
                }
            }
            .navigationTitle("Settings")
            .alert(isPresented: $showingImportSuccessAlert) {
                Alert(title: Text("Success"), message: Text("Parts imported successfully."), dismissButton: .default(Text("OK")))
            }
            .alert(isPresented: $showingExportSuccessAlert) {
                Alert(title: Text("Success"), message: Text("UserDefaults exported successfully."), dismissButton: .default(Text("OK")))
            }
            .sheet(isPresented: $showingShareSheet) {
                if let fileURL = fileURL {
                    ShareSheet(items: [fileURL])
                }
            }
            .fileImporter(isPresented: $showingDocumentPicker, allowedContentTypes: [.json]) { result in
                switch result {
                case .success(let url):
                    importPartsFromJSON(url: url)
                case .failure(let error):
                    print("Failed to import file: \(error.localizedDescription)")
                }
            }
        }
        .accentColor(.blue)
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
