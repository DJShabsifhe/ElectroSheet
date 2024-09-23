//
//  PartItem.swift
//  ElectroSheet
//
//  Created by DJShabsifhe on 2024/9/7.
//

import Foundation
import SwiftUI

struct PartItem: Identifiable, Codable {
    var id: UUID = UUID()
    var name: String
    var description: String
    var icon: String
    var colorString: String
    var isFavorite: Bool = false
    var favoriteDate: Date?
    var type: String
    var usage: String
    var special: String

    var color: Color {
        switch colorString {
        case "blue": return .blue
        case "green": return .green
        case "red": return .red
        case "yellow": return .yellow
        case "purple": return .purple
        default: return .black
        }
    }
}
