//
//  ProfileView.swift
//  ElectroSheet
//
//  Created by DJShabsifhe on 2024/9/7.
//

import SwiftUI

struct ProfileView: View {
    @State private var userName: String = "Admin"
    @State private var userEmail: String = "Admin@test.com"
    @State private var userStatus: String = "Club President"
    @State private var userImage: String = "person.circle" // Placeholder for profile image

    var body: some View {
        NavigationView {
            VStack {
//                HStack {
//                    Text("Profile")
//                        .font(.largeTitle)
//                        .foregroundColor(.black)
//                        .fontWeight(.bold)
//                        .padding()
//                }.padding(.top)
                VStack {
                    
                    Image(systemName: userImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.accentColor)
                        .padding()

                    Text(userName)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.bottom, 2)
                    
                    Text(userStatus)
                        .foregroundColor(.blue) // Customize color as needed
                        .fontWeight(.bold)

                    Text(userEmail)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding()
                .frame(width:300)
                .background(Color.accentColor.opacity(0.1))
                .cornerRadius(20)
                .padding()

                List {
                    NavigationLink(destination: Text("Edit Profile")) {
                        Text("Edit Profile")
                    }
                    NavigationLink(destination: Text("Change Password")) {
                        Text("Change Password")
                    }
                    NavigationLink(destination: Text("Privacy Settings")) {
                        Text("Privacy Settings")
                    }
                    NavigationLink(destination: Text("Notification Settings")) {
                        Text("Notification Settings")
                    }
                }
                
//                HStack {
//                    // Log Out Button
//                    Button(action: {
//                        // Handle log out action
//                    }) {
//                        Text("Log Out")
//                            .font(.headline)
//                            .foregroundColor(.white)
//                            .padding()
//                            .frame(maxWidth: .infinity)
//                            .background(Color.red.gradient.opacity(0.8))
//                            .cornerRadius(8)
//                    }
//                    .frame(width:300)
//                    .padding()
//                }

            }.navigationTitle("Profile")
        }
    }
}

#Preview {
    ProfileView()
}
