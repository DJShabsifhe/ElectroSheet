//
//  UserModel.swift
//  ElectroSheet
//
//  Created by DJShabsifhe on 2024/9/10.
//

import Foundation

struct User: Identifiable {
    var id = UUID()
    var name: String
    var email: String
    var status: String
    var password: String
    var photo: String
}
