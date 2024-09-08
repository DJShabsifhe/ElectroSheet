//
//  PartViewModel.swift
//  ElectroSheet
//
//  Created by DJShabsifhe on 2024/9/7.
//

import Foundation

class PartViewModel: ObservableObject {
    @Published var parts: [PartItem] = [] {
        didSet {
            saveParts()
        }
    }

    init() {
        loadParts()
    }

    func addPart(part: PartItem) {
        parts.append(part)
    }

    func toggleFavorite(for part: PartItem) {
        if let index = parts.firstIndex(where: { $0.id == part.id }) {
            parts[index].isFavorite.toggle()
            if parts[index].isFavorite {
                parts[index].favoriteDate = Date()
            } else {
                parts[index].favoriteDate = nil
            }
        }
    }

    func deletePart(_ part: PartItem) {
        if let index = parts.firstIndex(where: { $0.id == part.id }) {
            parts.remove(at: index)
        }
    }

    private func saveParts() {
        do {
            let encoded = try JSONEncoder().encode(parts)
            UserDefaults.standard.set(encoded, forKey: "parts")
        } catch {
            print("Failed to save parts: \(error)")
        }
    }

    private func loadParts() {
        if let data = UserDefaults.standard.data(forKey: "parts") {
            do {
                let decoded = try JSONDecoder().decode([PartItem].self, from: data)
                parts = decoded
            } catch {
                print("Failed to load parts: \(error)")
            }
        }
    }
}
