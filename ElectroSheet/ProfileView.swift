//
//  ProfileView.swift
//  ElectroSheet
//
//  Created by DJShabsifhe on 2024/9/7.
//

import SwiftUI

struct ProfileView: View {
    var user: User // Accept user as a parameter

    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    Image(systemName: user.photo)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.accentColor)
                        .padding()

                    Text(user.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.bottom, 2)
                    
                    Text(user.status)
                        .foregroundColor(.blue)
                        .fontWeight(.bold)

                    Text(user.email)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding()
                .frame(width: 300)
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
            }
            .navigationTitle("Profile")
        }
    }
}

#Preview {
    ProfileView(user: User(name: "Admin", email: "Admin@test.com", status: "Club President", password: "password", photo: "person.circle"))
}
