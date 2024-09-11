//
//  ImportDataView.swift
//  ElectroSheet
//
//  Created by DJShabsifhe on 2024/9/10.
//

import SwiftUI

struct ImportDataView: View {
    @ObservedObject var viewModel: PartViewModel
    @State private var isImporting = false
    @State private var selectedFileURL: URL?

    var body: some View {
        VStack {
            Text("Import Data from JSON")
                .font(.largeTitle)
                .padding()

            Button(action: {
                isImporting = true
            }) {
                Text("Select JSON File")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
            .fileImporter(isPresented: $isImporting, allowedContentTypes: [.json]) { result in
                switch result {
                case .success(let url):
                    selectedFileURL = url
                    importData(from: url)
                case .failure(let error):
                    print("Failed to import data: \(error.localizedDescription)")
                }
            }

            Spacer()
        }
        .padding()
    }

    private func importData(from url: URL) {
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601 // Adjust if needed
            let parts = try decoder.decode([PartItem].self, from: data)

            for part in parts {
                viewModel.addPart(part: part)
            }
            print("Data imported successfully")
        } catch {
            print("Failed to import data: \(error.localizedDescription)")
        }
    }
}
