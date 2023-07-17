//
//  ChatView.swift
//  BeerChat
//
//  Created by Jun on 2023/07/14.
//

import SwiftUI

struct ChatView: View {
    @StateObject var chatViewModel: ChatViewModel

    var chatRoomId: String
    var userId: String

    init(chatRoomId: String, userId: String) {
        self.chatRoomId = chatRoomId
        self.userId = userId
        self._chatViewModel = StateObject(wrappedValue: ChatViewModel(roomId: chatRoomId, userId: userId))
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
