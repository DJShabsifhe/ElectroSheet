//
//  PartItem.swift
//  ElectroSheet
//
//  Created by DJShabsifhe on 2024/9/7.
//

import Foundation
import SwiftUI

struct PartItem: Identifiable, Codable {
    var id = UUID()
    var name: String
    var description: String
    var icon: String
    var colorString: String // Store color as String

    // Computed property to get Color from the colorString
    var color: Color {
        switch colorString {
        case "blue": return .blue
        case "green": return .green
        case "red": return .red
        case "yellow": return .yellow
        case "purple": return .purple
        default: return .black // Fallback color
        }
    }
}
