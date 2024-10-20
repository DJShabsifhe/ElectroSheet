//
//  Home.swift
//  ElectroSheet
//
//  Created by DJShabsifhe on 2024/9/7.
//

import SwiftUI
import CoreMotion

struct Home: View {
    @ObservedObject var viewModel: PartViewModel
    
    @State private var isSearchFocused: Bool = false
    @State private var searchText: String = ""
    @State private var showingAddItem: Bool = false
    @State private var roll = Double.zero
    @State private var pitch = Double.zero
    
    let motionManager = CMMotionManager()
    let queue = OperationQueue()
    
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
                Text("ElectroSheets")
                    .font(.system(size: 40, weight: .heavy, design: .rounded))
                    .foregroundStyle(LinearGradient(
                        colors: [Color.blue.opacity(0.9), Color.purple.opacity(0.9)],
                        startPoint: .leading,
                        endPoint: .trailing
                    ))
                    .padding(.top, 20)
                    .padding(.horizontal, 20)
                    .multilineTextAlignment(.center)
                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: CGFloat(-roll * 5), y: CGFloat(-pitch * 5))
                    .offset(x: CGFloat(-roll * 5), y: CGFloat(-pitch * 5))
                
                HStack {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("Search Name", text: $searchText, onEditingChanged: { isEditing in
                            isSearchFocused = isEditing
                        })
                        .foregroundColor(.primary)
                        .disableAutocorrection(true)
                        
                        if !searchText.isEmpty {
                            Button(action: {
                                searchText = ""
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding(10)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray6)))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(isSearchFocused ? Color.accentColor : Color.clear, lineWidth: 1)
                    )
                    .animation(.easeInOut(duration: 0.3), value: isSearchFocused)
                    .padding(.horizontal, 10)
                    
                    Button(action: {
                        showingAddItem.toggle()
                    }) {
                        Label("Add", systemImage: "plus.circle.fill")
                            .labelStyle(IconOnlyLabelStyle())
                            .font(.system(size: 25))
                            .foregroundColor(Color.accentColor)
                    }
                    .padding(.trailing, 10)
                    .shadow(color: Color.black.opacity(0.3), radius: 3, x: 0, y: 3)
                }
                .padding(.horizontal)
                
                Spacer(minLength: 20)
                
                List {
                    ForEach(filteredParts) { part in
                        NavigationLink(destination: PartDetailView(part: part)) {
                            HStack {
                                Image(systemName: part.isFavorite ? "star.fill" : "star")
                                    .foregroundColor(part.isFavorite ? .yellow : .gray)
                                    .onTapGesture {
                                        withAnimation {
                                            viewModel.toggleFavorite(for: part)
                                        }
                                    }
                                
                                VStack(alignment: .leading) {
                                    Text(part.name)
                                        .font(.headline)
                                        .foregroundColor(part.color)
                                    Text(part.description)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                
                                Spacer()
                            }
                        }
                        .swipeActions {
                            Button(action: {
                                withAnimation {
                                    viewModel.toggleFavorite(for: part)
                                }
                            }) {
                                Label(part.isFavorite ? "Unfavorite" : "Favorite", systemImage: part.isFavorite ? "star.fill" : "star")
                            }
                            .tint(part.isFavorite ? .red : .yellow)

                            Button(role: .destructive, action: {
                                viewModel.deletePart(part)
                            }) {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                    .onDelete(perform: deleteParts)
                }
                .listStyle(InsetGroupedListStyle())
            }
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                self.motionManager.deviceMotionUpdateInterval = 1/60
                self.motionManager.startDeviceMotionUpdates(to: self.queue) { (data: CMDeviceMotion?, error: Error?) in
                    guard let data = data else {
                        print("Error: \(error!)")
                        return
                    }
                    let attitude = data.attitude
                    
                    DispatchQueue.main.async {
                        withAnimation(.spring(response: 0.33, dampingFraction: 0.33)) {
                            self.roll = attitude.roll // Horizontal rotation
                            self.pitch = attitude.pitch // Vertical rotation
                        }
                    }
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

#Preview {
    Home(viewModel: PartViewModel())
}
