import SwiftUI

struct FavoritesView: View {
    @ObservedObject var viewModel: PartViewModel

    var groupedFavorites: [Date: [PartItem]] {
        Dictionary(grouping: viewModel.parts.filter { $0.isFavorite && $0.favoriteDate != nil }) { part in
            Calendar.current.startOfDay(for: part.favoriteDate!) // Group by date
        }
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(groupedFavorites.keys.sorted(), id: \.self) { date in
                    Section(header: Text(date, style: .date)) {
                        ForEach(groupedFavorites[date]!) { part in
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
            .navigationTitle("Favorites")
        }
    }
}

#Preview {
    FavoritesView(viewModel: PartViewModel())
}
