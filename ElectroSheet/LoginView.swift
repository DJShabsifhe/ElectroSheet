//
//  LoginView.swift
//  ElectroSheet
//
//  Created by DJShabsifhe on 2024/9/10.
//

import SwiftUI
import Supabase

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var message: String = ""
    @EnvironmentObject var userManager: UserManager
    @State private var loggedInUser: User?

    var body: some View {
        if #available(iOS 16.0, *) {
            NavigationStack {
                VStack {
                    Text("Login")
                        .font(.largeTitle)
                    TextField("Email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    SecureField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    Button("Login") {
                        if let user = userManager.login(email: email, password: password) {
                            loggedInUser = user
                            message = "Login successful!"
                        } else {
                            message = "Invalid email or password."
                        }
                    }
                    .padding()
                    Text(message)
                        .foregroundColor(.red)
                        .padding()
                    
                    if let user = loggedInUser {
                        NavigationLink(destination: ProfileView(user: user)) {
                            Text("Go to Profile")
                        }
                    }
                }
                .padding()
            }
        } else {
            // to be added
        }
    }
}
