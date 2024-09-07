//
//  AddItemView.swift
//  ElectroSheet
//
//  Created by DJShabsifhe on 2024/9/7.
//

import Foundation
import SwiftUI

struct AddItemView: View {
    @Binding var partName: [String]
    @Binding var partImage: [String]
    @Binding var partDescription: [String]
    
    @State private var newName = ""
    @State private var newDescription = ""
    @State private var selectedIcon = "globe"
    @State private var selectedColor = Color.blue

    let icons = ["globe", "star", "heart", "bell"]
    let colors: [Color] = [.blue, .green, .red, .yellow, .purple]
    
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            Text("Add New Item")
                .font(.headline)
                .padding()

            TextField("Part Name", text: $newName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Description", text: $newDescription)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            // Icon Picker
            Picker("Select Icon", selection: $selectedIcon) {
                ForEach(icons, id: \.self) { icon in
                    Label(icon.capitalized, systemImage: icon)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding()

            // Color Picker
            Picker("Select Color", selection: $selectedColor) {
                ForEach(colors, id: \.self) { color in
                    Text(color.description.capitalized) // Display color name
                        .foregroundColor(color)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding()

            Button("Save") {
                if !newName.isEmpty && !newDescription.isEmpty {
                    partName.append(newName)
                    partDescription.append(newDescription)
                    partImage.append(selectedIcon) // Use selected icon

                    // Save to UserDefaults
                    UserDefaults.standard.set(partName, forKey: "partName")
                    UserDefaults.standard.set(partDescription, forKey: "partDescription")
                    UserDefaults.standard.set(partImage, forKey: "partImage")

                    newName = ""
                    newDescription = ""
                    presentationMode.wrappedValue.dismiss() // Close the view
                }
            }
            .padding()
            .background(selectedColor)
            .foregroundColor(.white)
            .cornerRadius(8)

            Spacer()
        }
        .padding()
    }
}

#Preview {
    AddItemView(partName: .constant([]), partImage: .constant([]), partDescription: .constant([]))
}
