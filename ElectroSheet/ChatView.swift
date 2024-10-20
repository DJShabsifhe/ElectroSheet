//
//  ChatView.swift
//  ElectroSheet
//
//  Created by DJShabsifhe on 2024/9/29.
//

import SwiftUI

struct ChatView: View {
    @State private var userInput: String = ""
    @State private var messages: [GPTMessage] = []
    @State private var isLoading: Bool = false

    var body: some View {
        VStack {
            HStack {
                Spacer()
            }
            .padding()
            .background(Color(UIColor.systemGray6))

            ScrollViewReader { scrollProxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(messages.indices, id: \.self) { index in
                            let message = messages[index]
                            HStack {
                                if message.role == "user" {
                                    Spacer()
                                    Text(message.content)
                                        .padding()
                                        .background(Color.blue.opacity(0.2))
                                        .cornerRadius(20)
                                        .frame(maxWidth: 300, alignment: .trailing)
                                        .scaleEffect(isLoading ? 0.95 : 1.0)
                                        .rotationEffect(isLoading ? .degrees(2) : .degrees(0))
                                        .transition(.asymmetric(insertion: .scale(scale: 1.2).combined(with: .opacity), removal: .opacity))
                                        .animation(.easeInOut(duration: 0.3), value: messages)
                                } else {
                                    Text(message.content)
                                        .padding()
                                        .background(Color.gray.opacity(0.2))
                                        .cornerRadius(20)
                                        .frame(maxWidth: 300, alignment: .leading)
                                        .scaleEffect(isLoading ? 0.95 : 1.0)
                                        .rotationEffect(isLoading ? .degrees(-2) : .degrees(0))
                                        .transition(.asymmetric(insertion: .scale(scale: 1.2).combined(with: .opacity), removal: .opacity))
                                        .animation(.easeInOut(duration: 0.3), value: messages)
                                    Spacer()
                                }
                            }
                            .id(index)
                        }
                    }
                    .padding()
                    .onChange(of: messages) { _ in
                        if let lastIndex = messages.indices.last {
                            scrollProxy.scrollTo(lastIndex, anchor: .bottom)
                        }
                    }
                }
            }

            VStack {
                Divider()

                HStack {
                    TextField("Type what you wanna add...", text: $userInput, onCommit: sendMessage)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                        .frame(minHeight: 44)

                    if isLoading {
                        ProgressView()
                            .padding(.trailing)
                    } else {
                        Button(action: sendMessage) {
                            Image(systemName: "paperplane.fill")
                                .foregroundColor(.blue)
                                .padding()
                        }
                        .disabled(userInput.isEmpty)
                    }
                }
                .padding()
                .background(Color(UIColor.systemGray6))
            }
        }
        .navigationTitle("Powered by ChatGPT-4o")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func sendMessage() {
        guard !userInput.isEmpty else { return }

        let userMessage = GPTMessage(role: "user", content: userInput)
        withAnimation {
            messages.append(userMessage)
        }
        userInput = ""
        isLoading = true

        Task {
            do {
                try await OpenAIService.shared.sendPrompt(message: userMessage.content)
                let responseMessage = GPTMessage(role: "assistant", content: "Sample response.") // Replace with actual response
                withAnimation {
                    messages.append(responseMessage)
                }
            } catch {
                let errorMessage = GPTMessage(role: "assistant", content: "Error: \(error.localizedDescription)")
                withAnimation {
                    messages.append(errorMessage)
                }
            }
            isLoading = false
        }
    }
}

#Preview {
    NavigationView {
        ChatView()
    }
}

//
//  ChatView.swift
//  DemoChat
//
//  Created by Sihao Lu on 3/25/23.
//

//import Combine
//import SwiftUI
//
//public struct ChatView: View {
//    @ObservedObject var store: ChatStore
//    
//    @Environment(\.dateProviderValue) var dateProvider
//    @Environment(\.idProviderValue) var idProvider
//
//    public init(store: ChatStore) {
//        self.store = store
//    }
//    
//    public var body: some View {
//        
//        if #available(iOS 16.0, *) {
//            NavigationSplitView {
//                ListView(
//                    conversations: $store.conversations,
//                    selectedConversationId: Binding<Conversation.ID?>(
//                        get: {
//                            store.selectedConversationID
//                        }, set: { newId in
//                            store.selectConversation(newId)
//                        })
//                )
//                .toolbar {
//                    ToolbarItem(
//                        placement: .primaryAction
//                    ) {
//                        Button(action: {
//                            store.createConversation()
//                        }) {
//                            Image(systemName: "plus")
//                        }
//                        .buttonStyle(.borderedProminent)
//                    }
//                }
//            } detail: {
//                if let conversation = store.selectedConversation {
//                    DetailView(
//                        conversation: conversation,
//                        error: store.conversationErrors[conversation.id],
//                        sendMessage: { message, selectedModel in
//                            Task {
//                                await store.sendMessage(
//                                    Message(
//                                        id: idProvider(),
//                                        role: .user,
//                                        content: message,
//                                        createdAt: dateProvider()
//                                    ),
//                                    conversationId: conversation.id,
//                                    model: selectedModel
//                                )
//                            }
//                        }
//                    )
//                }
//            }
//        } else {
//            // Fallback on earlier versions
//        }
//    }
//}
