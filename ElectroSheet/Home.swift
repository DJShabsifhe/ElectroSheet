//
//  Home.swift
//  ElectroSheet
//
//  Created by DJShabsifhe on 2024/9/7.
//

// Home.swift
import SwiftUI

struct Home: View {
    @ObservedObject var viewModel: PartViewModel
    
    @State private var searchText: String = ""
    @State private var showingAddItem: Bool = false

    var filteredParts: [PartItem] {
        if searchText.isEmpty {
            return viewModel.parts
        } else {
            return viewModel.parts.filter { $0.name.contains(searchText) }
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
//                    .frame(height: 50)
                    .font(.system(size: 18))

                Spacer()
                
                Button(action: {
                    showingAddItem.toggle()
                }) {
                    Text("Add")
                        .font(.system(size: 20))
                        .padding(8)
                        .background(Color.accentColor.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .frame(width: 60, height: 40)
            }
            .padding(.horizontal)

            List(filteredParts) { part in
                HStack {
                    Image(systemName: part.isFavorite ? "star.fill" : "star")
                        .foregroundColor(part.isFavorite ? .yellow : .gray)
                        .onTapGesture {
                            viewModel.toggleFavorite(for: part)
                        } // Alternative to Favorite
                    
                    Label(part.name, systemImage: part.icon)
                        .foregroundColor(part.color)
                    
                    Spacer()
                    
                    Text(part.description)
                }
                .swipeActions {
                    Button(action: {
                        viewModel.toggleFavorite(for: part)
                    }) {
                        Label(part.isFavorite ? "Unfavorite" : "Favorite", systemImage: part.isFavorite ? "star.fill" : "star")
                    }
                    .tint(part.isFavorite ? .red : .yellow)
                }
            }
        }
        .sheet(isPresented: $showingAddItem) {
            AddItem(viewModel: viewModel, showingAddItem: $showingAddItem)
        }
    }
}
