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
    
    // 添加 OpenAIHandler
    @StateObject private var openAIHandler = OpenAIHandler()

    @State private var selectedExportFormat: ExportFormat = .json
    let exportFormats: [ExportFormat] = [.json, .csv, .pdf]

    enum ExportFormat: String, CaseIterable, Identifiable {
        case json = "JSON"
        case csv = "CSV"
        case pdf = "PDF"
        
        var id: String { self.rawValue }
    }

    func exportUserDefaultsToJSON() -> URL? {
        // 跳过导出以防止崩溃
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
            print("在预览期间跳过导出")
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
            print("导出 UserDefaults 失败: \(error)")
            return nil
        }
    }

    func importPartsFromJSON(url: URL) {
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601 // 如有需要可调整
            let parts = try decoder.decode([PartItem].self, from: data)

            for part in parts {
                partViewModel.addPart(part: part)
            }
            print("数据导入成功")
        } catch {
            print("导入数据失败: \(error.localizedDescription)")
        }
    }

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("常规").font(.headline).foregroundColor(.primary)) {
                    NavigationLink(destination: ImportDataView(viewModel: PartViewModel())) {
                        Label("从 JSON 导入数据", systemImage: "square.and.arrow.down")
                            .font(.body)
                            .foregroundColor(.blue)
                    }
                    
                    NavigationLink(destination: ImportPDFView(openAIHandler: openAIHandler)) {
                        Label("从 PDF 导入数据", systemImage: "doc.richtext")
                            .font(.body)
                            .foregroundColor(.blue)
                    }
                    
                    Button(action: {
                        if let url = exportUserDefaultsToJSON() {
                            fileURL = url
                            showingShareSheet = true
                        }
                    }) {
                        Label("导出 UserDefaults 为 JSON", systemImage: "square.and.arrow.up")
                            .font(.body)
                            .foregroundColor(.blue)
                    }

                    NavigationLink(destination: StatisticsView(viewModel: partViewModel)) {
                        Label("查看统计", systemImage: "chart.bar")
                            .font(.body)
                            .foregroundColor(.blue)
                    }
                }
            }
            .navigationTitle("设置")
            .alert(isPresented: $showingImportSuccessAlert) {
                Alert(title: Text("成功"), message: Text("数据导入成功。"), dismissButton: .default(Text("确定")))
            }
            .alert(isPresented: $showingExportSuccessAlert) {
                Alert(title: Text("成功"), message: Text("UserDefaults 导出成功。"), dismissButton: .default(Text("确定")))
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
                    print("导入文件失败: \(error.localizedDescription)")
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
