import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = PartViewModel()
    @StateObject private var userManager = UserManager()
    @State var selectedSort = "Date"
    @State var currentSort = "Date"
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            Home(viewModel: viewModel)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(0)

            FavoritesView(viewModel: viewModel, selectedSort: $selectedSort)
                .tabItem {
                    Label("Favorites", systemImage: "star")
                }
                .tag(1)

            SettingsView(viewModel: viewModel)
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(2)

            if let loggedInUser = userManager.currentUser {
                ProfileView(user: loggedInUser)
                    .tabItem {
                        Label("Profile", systemImage: "person")
                    }
                    .tag(3)
            } else {
                Text("Please log in")
                    .tabItem {
                        Label("Profile", systemImage: "person")
                    }
                    .tag(3)
            }
        }
        .accentColor(.accentColor)
        .environmentObject(userManager)
    }
}

#Preview {
    ContentView()
}
