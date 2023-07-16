//
//  ChatListView.swift
//  BeerChat
//
//  Created by Jun on 2023/07/14.
//

import SwiftUI
import Firebase

struct ChatListView: View {
    @StateObject var firestoreManager: FirestoreManager = FirestoreManager()
    @State private var isLogin: Bool = false
    @State var userEmail = ""
    @State var userId = ""
    let firebaseAuth = Auth.auth()
    init() {
        if let user = firebaseAuth.currentUser {
            userEmail = user.email!
            userId = user.uid
            isLogin = true
        }
    }
    var body: some View {
        List {
            ForEach(firestoreManager.chatRooms, id: \.self.roomId) { chatRoom in
                NavigationLink(destination: ChatView(chatRoom: chatRoom, userId: userId)
                    .environmentObject(firestoreManager)) {
                        if let recentMessage = chatRoom.recentMessage {
                            Text("RoomId : \(chatRoom.roomId!) -")+Text(recentMessage.text)+Text(recentMessage.timestamp.description)
                        } else {
                            Text("RoomId : \(chatRoom.roomId!) - 채팅을 시작하세요.")
                        }
                    }
            }
        }
    }
}

struct ChatListView_Previews: PreviewProvider {
    static var previews: some View {
        ChatListView()
            .environmentObject(FirestoreManager())
    }
}
