//
//  Home.swift
//  ElectroSheet
//
//  Created by DJShabsifhe on 2024/9/7.
//

import Foundation

import SwiftUI

struct Home: View {
    @Binding var partName: [String]
    @Binding var partImage: [String]
    @Binding var partDescription: [String]
    
    @Binding var searchText: String
    @Binding var showingAddItem: Bool

    var filteredParts: [String] {
        if searchText.isEmpty {
            return partName
        } else {
            return partName.filter { $0.contains(searchText) }
        }
    }

    var body: some View {
        VStack {
            HStack {
                Text("ElectroSheets")
                    .font(.largeTitle)
                    .foregroundColor(.accentColor)
                    .fontWeight(.bold)
                    .padding()
            }
            .padding(.top)

            HStack {
                TextField("Search", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .font(.system(size: 22))
                
                Spacer()
                
                Button(action: {
                    showingAddItem.toggle()
                }) {
                    Text("Add")
                        .font(.system(size: 20))
                        .padding(8)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .frame(width: 60, height: 40)
            }
            .padding(.horizontal)

            List(filteredParts.indices, id: \.self) { index in
                HStack {
                    Label(filteredParts[index], systemImage: partImage[index])
                        .foregroundColor(Color.blue) // Default color for the label
                        .font(.headline)
                    Spacer()
                    Text(partDescription[index])
                }
                .foregroundColor(Color.blue) // Set the text color for the description
                .background(Color.clear) // Optional: Set background color to clear
            }
        }
    }
}
