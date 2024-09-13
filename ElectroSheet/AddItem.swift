//
//  AddItem.swift
//  ElectroSheet
//
//  Created by DJShabsifhe on 2024/9/7.
//

import Foundation
import SwiftUI

struct AddItem: View {
    @ObservedObject var viewModel: PartViewModel
    @Binding var showingAddItem: Bool
    
    @State private var newName = ""
    @State private var newDescription = ""
    @State private var newType = ""
    @State private var newUsage = ""
    @State private var newSpecial = ""
    @State private var selectedIcon = "globe"
    @State private var selectedColor = Color.blue

    let icons = ["globe", "star", "heart", "bell"]
    let colors: [Color] = [.blue, .green, .red, .yellow, .purple]

    var body: some View {
        VStack(alignment: .leading) {
            // Title
            Text("Add New Part")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .padding(.bottom, 20)

            // Input Fields
            customTextField("Part Name", text: $newName)
            customTextField("Description", text: $newDescription)
            customTextField("Type", text: $newType)
            customTextField("Usage", text: $newUsage)
            customTextField("Special", text: $newSpecial)
                .padding(.bottom, 20)

            // Icon and Color Selection
            HStack {
                customPicker("Select Icon", selection: $selectedIcon, items: icons)
                customColorPicker("Select Color", selection: $selectedColor)
            }
            .padding(.bottom, 20)

            // Save Button
            Button(action: {
                if !newName.isEmpty && !newDescription.isEmpty && !newType.isEmpty && !newUsage.isEmpty && !newSpecial.isEmpty {
                    let newPart = PartItem(
                        name: newName,
                        description: newDescription,
                        icon: selectedIcon,
                        colorString: colorToString(selectedColor),
                        type: newType,
                        usage: newUsage,
                        special: newSpecial
                    )
                    viewModel.addPart(part: newPart)
                    clearFields()
                    showingAddItem = false
                }
            }) {
                Text("Save")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .shadow(color: Color.accentColor.opacity(0.3), radius: 5, x: 0, y: 4)
            }
            .padding(.bottom, 20)

            Spacer()
        }
        .padding(30)
        .background(Color(.systemGroupedBackground))
        .cornerRadius(20)
        .shadow(radius: 10)
        .edgesIgnoringSafeArea(.bottom) // Remove bottom safe area padding
    }

    // Custom TextField with rounded style and padding
    private func customTextField(_ placeholder: String, text: Binding<String>) -> some View {
        TextField(placeholder, text: text)
            .padding()
            .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))
            .font(.body)
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.3), lineWidth: 1))
            .padding(.bottom, 15)
    }

    // Custom Picker for selecting icons
    private func customPicker(_ title: String, selection: Binding<String>, items: [String]) -> some View {
        Menu {
            ForEach(items, id: \.self) { item in
                Button(action: {
                    selection.wrappedValue = item
                }) {
                    Label(item.capitalized, systemImage: item)
                }
            }
        } label: {
            HStack {
                Text(title)
                Image(systemName: selection.wrappedValue)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.3), lineWidth: 1))
        }
    }

    // Custom Color Picker for selecting colors
    private func customColorPicker(_ title: String, selection: Binding<Color>) -> some View {
        Menu {
            ForEach(colors, id: \.self) { color in
                Button(action: {
                    selection.wrappedValue = color
                }) {
                    HStack {
                        Circle()
                            .fill(color)
                            .frame(width: 24, height: 24)
                        Text(color.description.capitalized)
                            .foregroundColor(.primary)
                    }
                }
            }
        } label: {
            HStack {
                Text(title)
                Circle()
                    .fill(selection.wrappedValue)
                    .frame(width: 24, height: 24)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.3), lineWidth: 1))
        }
    }

    private func clearFields() {
        newName = ""
        newDescription = ""
        newType = ""
        newUsage = ""
        newSpecial = ""
    }

    private func colorToString(_ color: Color) -> String {
        switch color {
        case .blue:
            return "blue"
        case .green:
            return "green"
        case .red:
            return "red"
        case .yellow:
            return "yellow"
        case .purple:
            return "purple"
        default:
            return "unknown"
        }
    }
}
