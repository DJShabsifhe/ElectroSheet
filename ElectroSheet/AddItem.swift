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

            TextField("Part Name", text: $newName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .frame(width: 250)
                .shadow(color: Color.gray, radius: 2, x: 2, y: 2)

            TextField("Description", text: $newDescription)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .frame(width: 250)
                .shadow(color: Color.gray, radius: 2, x: 2, y: 2)

            TextField("Type", text: $newType)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .frame(width: 250)
                .shadow(color: Color.gray, radius: 2, x: 2, y: 2)

            TextField("Usage", text: $newUsage)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .frame(width: 250)
                .shadow(color: Color.gray, radius: 2, x: 2, y: 2)

            TextField("Special", text: $newSpecial)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .frame(width: 250)
                .shadow(color: Color.gray, radius: 2, x: 2, y: 2)

            HStack {
                Picker("Select Icon", selection: $selectedIcon) {
                    ForEach(icons, id: \.self) { icon in
                        Label(icon.capitalized, systemImage: icon)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding()
                
                Picker("Select Color", selection: $selectedColor) {
                    ForEach(colors, id: \.self) { color in
                        Text(color.description.capitalized)
                            .foregroundColor(color)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding()
            }
            
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

                    newName = ""
                    newDescription = ""
                    newType = ""
                    newUsage = ""
                    newSpecial = ""
                    showingAddItem = false
                }
            }
            .padding()
            .foregroundColor(.blue)
            .cornerRadius(8)
            .font(.system(size: 20))
            .disabled(newName.isEmpty || newDescription.isEmpty || newType.isEmpty || newUsage.isEmpty || newSpecial.isEmpty)
            
            Spacer()
        }
        .padding()
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
