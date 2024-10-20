//
//  Conversation.swift
//  ElectroSheet
//
//  Created by DJShabsifhe on 2024/10/11.
//

import Foundation

struct Conversation {
    init(id: String, messages: [Message] = []) {
        self.id = id
        self.messages = messages
    }
    
    typealias ID = String
    
    let id: String
    var messages: [Message]
}

extension Conversation: Equatable, Identifiable {}
