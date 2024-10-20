//
//  ContentView.swift
//  ElectroSheet
//
//  Created by DJShabsifhe on 2024/9/7.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = PartViewModel()
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
            
            ChatView()
                .tabItem {
                    Label("ChatGPT", systemImage: "brain")
                }
                .tag(2) // Added tag for ChatView
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(3) // Changed to tag 3 for consistency
        }
        .task {
            do {
                try await OpenAIService.shared.sendPrompt(message: "555")
            } catch {
                print(error.localizedDescription)
            }
        }
        .navigationTitle("ElectroSheet") // Optional: Set a navigation title
    }
}

#Preview {
    ContentView()
}
