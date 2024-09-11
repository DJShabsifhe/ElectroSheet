//
//  FavoriteView.swift
//  ElectroSheet
//
//  Created by DJShabsifhe on 2024/9/7.
//

import SwiftUI

struct FavoritesView: View {
    @ObservedObject var viewModel: PartViewModel
    @Binding var selectedSort: String // Use the binding directly
    
    var groupedFavorites: [Date: [PartItem]] {
        Dictionary(grouping: sortedFavorites()) { part in
            Calendar.current.startOfDay(for: part.favoriteDate!)
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(groupedFavorites.keys.sorted(), id: \.self) { date in
                    Section(header: Text(date, style: .date)) {
                        ForEach(groupedFavorites[date]!) { part in
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
