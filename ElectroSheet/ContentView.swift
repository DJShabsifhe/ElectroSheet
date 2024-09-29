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
                    Label("Chat", systemImage: "brain.head.profile")
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(2)
        }
        .task {
            do {
                try await OpenAIService.shared.sendPrompt(message: "555")
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

#Preview {
    ContentView()
}
