//
//  Home.swift
//  ElectroSheet
//
//  Created by DJShabsifhe on 2024/9/7.
//

import SwiftUI

struct Home: View {
    @ObservedObject var viewModel: PartViewModel
    
    @State private var isSearchFocused: Bool = false
    
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
        NavigationView {
            VStack {
                HStack {
                    Text("ElectroSheets")
                        .font(.largeTitle)
                        .foregroundColor(.primary)
                        .fontWeight(.bold)
                        .padding()
                        .shadow(color: Color.accentColor.opacity(0.5), radius: 1, x: 2, y: 2)
                }
                .padding(.top)

                HStack {
                    TextField("Search", text: $searchText, onEditingChanged: { isEditing in
                        isSearchFocused = isEditing // Update focus state
                    })
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .font(.system(size: 18))
                    .shadow(color: isSearchFocused ? Color.accentColor.opacity(0.5) : Color.clear, radius: 2, x: 2, y: 2)
                    .padding(5)

                    Spacer()
                    
                    Button(action: {
                        showingAddItem.toggle()
                    }) {
                        Text("Add")
                            .font(.system(size: 20))
                            .padding(8)
                            .background(Color.accentColor)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .frame(width: 60, height: 40) // Adjust height for better appearance
                    .shadow(color: Color.black.opacity(0.3), radius: 4, x: 2, y: 2)
                }
                .padding(.horizontal)
                List {
                    ForEach(filteredParts) { part in
                        NavigationLink(destination: PartDetailView(part: part)) {
                            HStack {
                                Image(systemName: part.isFavorite ? "star.fill" : "star")
                                    .foregroundColor(part.isFavorite ? .yellow : .gray)
                                    .onTapGesture {
                                        viewModel.toggleFavorite(for: part)
                                    }
                                
                                Label(part.name, systemImage: part.icon)
                                    .foregroundColor(part.color)
                                
                                Spacer()
                                
                                Text(part.description)
                                    .foregroundColor(.gray)
                            }
                        }
                        .swipeActions {
                            Button(action: {
                                viewModel.toggleFavorite(for: part)
                            }) {
                                Label(part.isFavorite ? "Unfavorite" : "Favorite", systemImage: part.isFavorite ? "star.fill" : "star")
                            }
                            .tint(part.isFavorite ? .red : .yellow)

                            // Delete Action
                            Button(role: .destructive, action: {
                                viewModel.deletePart(part)
                            }) {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                    .onDelete(perform: deleteParts)
                }
            }
            .sheet(isPresented: $showingAddItem) {
                AddItem(viewModel: viewModel, showingAddItem: $showingAddItem)
            }
        }
    }

    private func deleteParts(at offsets: IndexSet) {
        for index in offsets {
            let part = filteredParts[index]
            viewModel.deletePart(part)
        }
    }
}
