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
    @State private var selectedFilter: FilterOption = .all
    @State private var selectedSort: SortOption = .nameAscending

    var filteredParts: [PartItem] {
        var parts = viewModel.parts
        
        // 搜索过滤
        if !searchText.isEmpty {
            parts = parts.filter { $0.name.contains(searchText) || $0.description.contains(searchText) }
        }
        
        // 基于筛选选项进行过滤
        switch selectedFilter {
        case .all:
            break
        case .favorites:
            parts = parts.filter { $0.isFavorite }
        case .type(let type):
            parts = parts.filter { $0.type == type }
        }
        
        // 排序
        switch selectedSort {
        case .nameAscending:
            parts = parts.sorted { $0.name < $1.name }
        case .nameDescending:
            parts = parts.sorted { $0.name > $1.name }
        case .dateAscending:
            parts = parts.sorted { ($0.favoriteDate ?? Date()) < ($1.favoriteDate ?? Date()) }
        case .dateDescending:
            parts = parts.sorted { ($0.favoriteDate ?? Date()) > ($1.favoriteDate ?? Date()) }
        }
        
        return parts
    }

    var body: some View {
        NavigationView {
            VStack {
                // 搜索栏
                HStack {
                    TextField("搜索部件...", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    Button(action: {
                        isSearchFocused.toggle()
                        searchText = ""
                    }) {
                        Image(systemName: isSearchFocused ? "xmark.circle.fill" : "magnifyingglass")
                            .foregroundColor(.gray)
                    }
                    .padding(.trailing)
                }
                .padding(.top)
                
                // 筛选和排序
                HStack {
                    Picker("筛选", selection: $selectedFilter) {
                        ForEach(FilterOption.allCases, id: \.self) { option in
                            Text(option.displayName).tag(option)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    
                    Picker("排序", selection: $selectedSort) {
                        ForEach(SortOption.allCases, id: \.self) { option in
                            Text(option.displayName).tag(option)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                .padding(.horizontal)
                
                List(filteredParts) { part in
                    NavigationLink(destination: PartDetailView(part: part)) {
                        HStack {
                            Image(part.icon)
                                .resizable()
                                .frame(width: 50, height: 50)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .padding(.trailing, 10)
                            VStack(alignment: .leading) {
                                Text(part.name)
                                    .font(.headline)
                                Text(part.description)
                                    .font(.subheadline)
                                    .lineLimit(2)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            if part.isFavorite {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                            }
                        }
                        .padding(.vertical, 5)
                    }
                }
            }
            .navigationTitle("ElectroSheets")
            .navigationBarItems(trailing: Button(action: {
                showingAddItem = true
            }) {
                Image(systemName: "plus")
            })
            .sheet(isPresented: $showingAddItem) {
                AddItemView(partName: <#Binding<[String]>#>, partImage: <#Binding<[String]>#>, partDescription: <#Binding<[String]>#>)
                // fix this later
            }
        }
    }
}

enum FilterOption: Hashable, CaseIterable {
    case all
    case favorites
    case type(String)
    
    static var allCases: [FilterOption] {
        return [.all, .favorites] // Add more specific types if needed
    }
    
    var displayName: String {
        switch self {
        case .all:
            return "全部"
        case .favorites:
            return "收藏"
        case .type(let type):
            return type
        }
    }
}

enum SortOption: CaseIterable {
    case nameAscending
    case nameDescending
    case dateAscending
    case dateDescending
    
    var displayName: String {
        switch self {
        case .nameAscending:
            return "名称 A-Z"
        case .nameDescending:
            return "名称 Z-A"
        case .dateAscending:
            return "日期 旧到新"
        case .dateDescending:
            return "日期 新到旧"
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home(viewModel: PartViewModel())
    }
}
