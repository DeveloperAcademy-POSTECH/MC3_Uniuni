//
//  ChatView.swift
//  BeerChat
//
//  Created by Jun on 2023/07/14.
//

import SwiftUI

struct ChatView: View {
    @EnvironmentObject var firestoreManager: FirestoreManager
    @ObservedObject var chatViewModel: ChatViewModel

    var chatRoom: ChatRoom
    var userId: String

    init(chatRoom: ChatRoom, userId: String) {
        self.chatRoom = chatRoom
        self.userId = userId
        self.chatViewModel = ChatViewModel(roomId: chatRoom.roomId!, userId: userId)
    }

    var body: some View {
        VStack {
            // 채팅 메시지 표시
            ScrollViewReader { proxy in
                ScrollView {
                    ForEach(chatViewModel.messages, id: \.id) { message in
                        ChatBubble(message: message, userId: userId)
                    }
                }
            }
            
            ChatField()
                .frame(height: 80)
                .environmentObject(chatViewModel)
        }
    }
}
