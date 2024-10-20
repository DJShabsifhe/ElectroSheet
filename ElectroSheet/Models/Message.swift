//
//  Message.swift
//  ElectroSheet
//
//  Created by DJShabsifhe on 2024/10/11.
//

import Foundation
import OpenAI

struct Message {
    var id: String
    var role: ChatQuery.ChatCompletionMessageParam.Role
    var content: String
    var createdAt: Date
}

extension Message: Equatable, Codable, Hashable, Identifiable {}
