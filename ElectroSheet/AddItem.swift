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
        VStack {
            Text("Add New Item")
                .font(.title2)
                .padding()

            customTextField("Part Name", text: $newName)
            customTextField("Description", text: $newDescription)
            customTextField("Type", text: $newType)
            customTextField("Usage", text: $newUsage)
            customTextField("Special", text: $newSpecial)

            HStack {
                customPicker("Select Icon", selection: $selectedIcon, items: icons)
                customColorPicker("Select Color", selection: $selectedColor)
            }
            .padding()

            Button("Save") {
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
            }
            .buttonStyle(CustomButtonStyle())
            .padding()

            Spacer()
        }
        .padding()
    }

    private func customTextField(_ placeholder: String, text: Binding<String>) -> some View {
        TextField(placeholder, text: text)
            .textFieldStyle(PlainTextFieldStyle())
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: Color.gray.opacity(0.5), radius: 5, x: 0, y: 2)
    }

    private func customPicker(_ title: String, selection: Binding<String>, items: [String]) -> some View {
        Picker(title, selection: selection) {
            ForEach(items, id: \.self) { item in
                Label(item.capitalized, systemImage: item)
            }
        }
        .pickerStyle(MenuPickerStyle())
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.gray.opacity(0.5), radius: 5, x: 0, y: 2)
    }

    private func customColorPicker(_ title: String, selection: Binding<Color>) -> some View {
        Menu {
            ForEach(colors, id: \.self) { color in
                Button(action: {
                    selection.wrappedValue = color
                }) {
                    Text(color.description.capitalized)
                        .foregroundColor(color)
                }
            }
        } label: {
            Text(title)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: Color.gray.opacity(0.5), radius: 5, x: 0, y: 2)
        }
        .padding()
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

// Custom button style for consistent appearance
struct CustomButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .padding()
            .background(Color.blue)
            .cornerRadius(10)
            .shadow(color: configuration.isPressed ? Color.gray.opacity(0.5) : Color.clear, radius: 5, x: 0, y: 2)
    }
}
