//
//  PartViewModel.swift
//  ElectroSheet
//
//  Created by DJShabsifhe on 2024/9/7.
//

import Foundation
import SwiftUI

class PartViewModel: ObservableObject {
    @Published var parts: [PartItem] = [] {
        didSet {
            saveParts()
        }
    }

    init() {
        loadParts()
    }

    func addPart(name: String, description: String, icon: String, color: Color) {
        let newPart = PartItem(name: name, description: description, icon: icon, colorString: String(describing: color))
        parts.append(newPart)
    }

    func toggleFavorite(for part: PartItem) {
        if let index = parts.firstIndex(where: { $0.id == part.id }) {
            parts[index].isFavorite.toggle()
            // Record the favorite date
            if parts[index].isFavorite {
                parts[index].favoriteDate = Date()
            } else {
                parts[index].favoriteDate = nil
            }
        }
    }

    private func saveParts() {
        if let encoded = try? JSONEncoder().encode(parts) {
            UserDefaults.standard.set(encoded, forKey: "parts")
        }
    }

    private func loadParts() {
        if let data = UserDefaults.standard.data(forKey: "parts"),
           let decoded = try? JSONDecoder().decode([PartItem].self, from: data) {
            parts = decoded
        }
    }
}
