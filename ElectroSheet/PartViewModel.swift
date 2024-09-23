//
//  PartViewModel.swift
//  ElectroSheet
//
//  Created by DJShabsifhe on 2024/9/7.
//

import Foundation
import SwiftUI
import Combine

class PartViewModel: ObservableObject {
    @Published var parts: [PartItem] = []
    private var cancellables = Set<AnyCancellable>()
    private let cloudKey = "cloudParts"
    private let networkMonitor = NetworkMonitor()

    
    init() {
        loadParts()
        setupSubscribers()
        
        networkMonitor.$isConnected
            .sink { [weak self] connected in
                if connected {
                    self?.syncWithCloud()
                }
            }
            .store(in: &cancellables)
    }
    
    func addPart(part: PartItem) {
        parts.append(part)
        saveParts()
    }
    
    func removePart(at offsets: IndexSet) {
        parts.remove(atOffsets: offsets)
        saveParts()
    }
    
    private func loadParts() {
        if let data = UserDefaults.standard.data(forKey: "parts") {
            do {
                let decoded = try JSONDecoder().decode([PartItem].self, from: data)
                parts = decoded
            } catch {
                print("加载部件失败: \(error)")
            }
        }
    }
    
    private func saveParts() {
        do {
            let data = try JSONEncoder().encode(parts)
            UserDefaults.standard.set(data, forKey: "parts")
        } catch {
            print("保存部件失败: \(error)")
        }
    }

        private func setupSubscribers() {
        $parts
            .debounce(for: .seconds(1), scheduler: RunLoop.main)
            .sink { [weak self] newParts in
                self?.saveParts()
                if self?.networkMonitor.isConnected == true {
                    self?.syncWithCloud()
                }
            }
            .store(in: &cancellables)
    }
    
    private func syncWithCloud() {
        // icloud
        do {
            let data = try JSONEncoder().encode(parts)
            UserDefaults(suiteName: "iCloud.com.yourapp.ElectroSheet")?.set(data, forKey: cloudKey)
            print("同步到云端成功")
        } catch {
            print("同步到云端失败: \(error)")
        }
    }
}
