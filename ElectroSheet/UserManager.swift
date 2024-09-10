//
//  UserManager.swift
//  ElectroSheet
//
//  Created by DJShabsifhe on 2024/9/10.
//

import Foundation
import Combine

class UserManager: ObservableObject {
    @Published var currentUser: User?
    
    private var users: [User] = [
        User(name: "Alice", email: "alice@example.com", status: "Club President", password: "password1", photo: "person.circle"),
        User(name: "Bob", email: "bob@example.com", status: "Club Vice President", password: "password2", photo: "person.circle"),
        User(name: "Charlie", email: "charlie@example.com", status: "Member", password: "password3", photo: "person.circle")
    ]

    func login(email: String, password: String) -> User? {
        if let user = users.first(where: { $0.email == email && $0.password == password }) {
            currentUser = user
            return user
        }
        return nil
    }

    func logout() {
        currentUser = nil
    }
}
