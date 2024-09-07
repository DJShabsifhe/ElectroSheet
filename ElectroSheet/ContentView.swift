//
//  ContentView.swift
//  ElectroSheet
//
//  Created by DJShabsifhe on 2024/9/7.
//

import SwiftUI

struct ContentView: View {
    @State private var partName: [String] = UserDefaults.standard.stringArray(forKey: "partName") ?? ["a", "b", "c"]
    @State private var partImage: [String] = UserDefaults.standard.stringArray(forKey: "partImage") ?? ["globe", "globe", "globe"]
    @State private var partDescription: [String] = UserDefaults.standard.stringArray(forKey: "partDescription") ?? ["Description A", "Description B", "Description C"]
    
    @State private var searchText = ""
    @State private var showingAddItem = false
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            Home(partName: $partName, partImage: $partImage, partDescription: $partDescription, searchText: $searchText, showingAddItem: $showingAddItem)
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
        .sheet(isPresented: $showingAddItem) {
            AddItem(partName: $partName, partImage: $partImage, partDescription: $partDescription, showingAddItem: $showingAddItem)
        }
    }
}

#Preview {
    ContentView()
}
