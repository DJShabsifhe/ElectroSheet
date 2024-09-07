//
//  AddItem.swift
//  ElectroSheet
//
//  Created by DJShabsifhe on 2024/9/7.
//

// bugs to be fixed: adding item with color

import Foundation
import SwiftUI

struct AddItem: View {
    @ObservedObject var viewModel: PartViewModel
    
    @Binding var showingAddItem: Bool
    @State private var newName = ""
    @State private var newDescription = ""
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

            TextField("Description", text: $newDescription)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
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
                if !newName.isEmpty && !newDescription.isEmpty {
                    viewModel.addPart(name: newName, description: newDescription, icon: selectedIcon, color: selectedColor)

                    // Clear input fields
                    newName = ""
                    newDescription = ""
                    showingAddItem = false
                }
            }
            .padding()
            .foregroundColor(.blue)
            .cornerRadius(8)
            .font(.system(size: 20))
            
            Spacer()
        }
        .padding()
    }
}
