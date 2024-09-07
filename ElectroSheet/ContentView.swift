//
//  ContentView.swift
//  ElectroSheet
//
//  Created by DJShabsifhe on 2024/9/7.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = PartViewModel()
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            Home(viewModel: viewModel)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(0)

            Text("Favorites Section")
                .tabItem {
                    Label("Favorites", systemImage: "star")
                }
                .tag(1)

            Text("Settings Section")
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(2)

            Text("Profile Section")
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
                .tag(3)
        }
    }
}

#Preview {
    ContentView()
}
