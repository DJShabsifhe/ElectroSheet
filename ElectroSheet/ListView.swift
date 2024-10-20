//
//  ListView.swift
//  DemoChat
//
//  Created by Sihao Lu on 3/25/23.
//

import SwiftUI

struct ListView: View {
    @Binding var conversations: [Conversation]
    @Binding var selectedConversationId: Conversation.ID?
    
    var body: some View {
        if #available(iOS 16.0, *) {
            List(
                $conversations,
                editActions: [.delete],
                selection: $selectedConversationId
            ) { $conversation in
                Text(
                    conversation.messages.last?.content ?? "New Conversation"
                )
                .lineLimit(2)
            }
            .navigationTitle("Conversations")
        } else {
            // Fallback on earlier versions
        }
    }
}
