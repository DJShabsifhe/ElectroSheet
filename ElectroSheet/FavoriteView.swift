//
//  FavoriteView.swift
//  ElectroSheet
//
//  Created by DJShabsifhe on 2024/9/7.
//

import SwiftUI

struct FavoritesView: View {
    @ObservedObject var viewModel: PartViewModel
    @Binding var selectedSort: String
    
    var sortOptions = ["Date", "Name", "Description"]
    
    var groupedFavorites: [String: [PartItem]] {
        switch selectedSort {
        case "Date":
            return Dictionary(grouping: sortedFavorites()) { part in
                let date = part.favoriteDate ?? Date()
                return DateFormatter.localizedString(from: date, dateStyle: .medium, timeStyle: .none)
            }
        case "Name":
            return Dictionary(grouping: sortedFavorites()) { part in
                String(part.name.prefix(1)).uppercased() // Group by the first letter of the name
            }
        case "Description":
            return Dictionary(grouping: sortedFavorites()) { part in
                String(part.description.prefix(1)).uppercased() // Group by the first letter of the description
            }
        default:
            return [:]
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // Sort Picker
                Picker("Sort by", selection: $selectedSort) {
                    ForEach(sortOptions, id: \.self) { option in
                        Text(option)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                // List of Favorites
                List {
                    ForEach(groupedFavorites.keys.sorted(), id: \.self) { key in
                        Section(header: Text(key)) {
                            ForEach(groupedFavorites[key]!) { part in
                                NavigationLink(destination: PartDetailView(part: part)) {
                                    HStack {
                                        Image(systemName: part.icon)
                                            .foregroundColor(part.color)
                                        Text(part.name)
                                            .foregroundColor(part.color)
                                        Spacer()
                                        Text(part.description)
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                        }
                    }
                }
                .navigationTitle("Favorites")
            }
        }
    }
    
    private func sortedFavorites() -> [PartItem] {
        let favorites = viewModel.parts.filter { $0.isFavorite }
        
        switch selectedSort {
        case "Date":
            return favorites.sorted {
                ($0.favoriteDate ?? Date()) > ($1.favoriteDate ?? Date())
            }
        case "Name":
            return favorites.sorted {
                $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
            }
        case "Description":
            return favorites.sorted {
                $0.description.localizedCaseInsensitiveCompare($1.description) == .orderedAscending
            }
        default:
            return favorites
        }
    }
}

#Preview {
    FavoritesView(viewModel: PartViewModel(), selectedSort: .constant("Date"))
}
