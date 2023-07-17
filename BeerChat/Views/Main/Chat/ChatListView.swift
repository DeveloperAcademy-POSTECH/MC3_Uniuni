//
//  ChatListView.swift
//  BeerChat
//
//  Created by Jun on 2023/07/14.
//

import SwiftUI
import Firebase

struct ChatListView: View {
    @EnvironmentObject var firestoreManager: FirestoreManager
    @State private var isLogin: Bool = false
    @Binding var chatRoomId: String
    @State var userEmail = ""
    @State var userId = ""
    @State var searchingText = ""
    let firebaseAuth = Auth.auth()
    var body: some View {
        List {
            ForEach(firestoreManager.chatRooms, id: \.self.roomId) { chatRoom in
                NavigationLink(destination: ChatView(chatRoom: chatRoom, userId: userId)
                    .environmentObject(firestoreManager)) {
                        if let recentMessage = chatRoom.recentMessage {
                            HStack {
                                Image(systemName: "person.fill")
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text(chatRoom.keyword)
                                        Text(userId == chatRoom.questioner ? "질문" : "답변")
                                            .font(.caption2)
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(
                                                Rectangle()
                                                    .fill(userId == chatRoom.questioner ? .indigo : .purple)
                                                    .cornerRadius(12)
                                            )
                                            .opacity(0.8)
                                        Text(chatRoom.status != "end" ? "진행" : "종료")
                                            .font(.caption2)
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(
                                                Rectangle()
                                                    .fill(chatRoom.status != "end" ? .blue : Color(UIColor.systemGray4))
                                                    .cornerRadius(12)
                                            )
                                            .opacity(0.8)
                                    }
                                    Text(recentMessage.text)
                                        .font(.caption2)
                                }
                                .padding(8)
                                Spacer()
                                Text(chatRoom.recentMessage!.timestamp.formatted(.dateTime.year().month().day()))
                                    .font(.caption2)
                            }
                        } else {
                            Text("RoomId : \(chatRoom.roomId!) - 채팅을 시작하세요.")
                        }
                    }
            }
        }
        .onAppear {
            if let user = UserManager.shared.currentUser {
                if let uid = user.userId {
                    userId = uid
                }
            }
        }
    }
}

struct ChatListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ChatListView(chatRoomId: .constant(""))
                .environmentObject(FirestoreManager())
        }
    }
}
