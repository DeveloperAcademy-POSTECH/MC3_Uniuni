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
            List(chatViewModel.messages, id: \.id) { message in
                Text((message.uid == userId ? "나" : "상대방")+" : \(message.text)")
            }
            // 메시지 작성 필드
            HStack {
                TextField("메시지 입력", text: $chatViewModel.newMessageText)
                Button("전송") {
                    chatViewModel.sendMessage()
                }
            }
        }
    }
}

//struct ChatView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatView()
//    }
//}
