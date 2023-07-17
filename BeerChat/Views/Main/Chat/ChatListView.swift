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
    @State private var isLogin = false
    @State var userEmail = ""
    @State var userId: String
    @State var text = ""
    let firebaseAuth = Auth.auth()

    init() {
        _userId = State(initialValue: "")
        if let user = UserManager.shared.currentUser {
            if let uid = user.userId {
                _userId = State(initialValue: uid)
            }
        }
    }
    enum Identity: String {
        case question = "질문"
        case reply = "답변"
    }
    enum Status: String {
        case proceeding = "진행"
        case end = "종료"
    }
    var body: some View {
        VStack {
            SearchBar(text: $text)
            List {
                ForEach(firestoreManager.chatRooms, id: \.self.roomId) { chatRoom in
                    NavigationLink(destination: ChatView(chatRoom: chatRoom, userId: userId)
                        .environmentObject(firestoreManager)) {
                            if let recentMessage = chatRoom.recentMessage {
                                HStack {
                                    Image(systemName: "person.fill")
                                        .foregroundColor(Color(UIColor.systemGray2))
                                        .background (
                                            Circle()
                                                .fill(Color(UIColor.systemGray6))
                                                .frame(width: 28, height: 28)
                                        )
                                    VStack(alignment: .leading) {
                                        HStack {
                                            Text(chatRoom.keyword)
                                            Text(userId == chatRoom.questioner ? Identity.question.rawValue : Identity.reply.rawValue)
                                                .font(.caption2)
                                                .foregroundColor(.white)
                                                .padding(.horizontal, 8)
                                                .padding(.vertical, 4)
                                                .background (
                                                    RoundedRectangle(cornerRadius: 12)
                                                        .fill(userId == chatRoom.questioner ? .indigo : .purple)
                                                )
                                                .opacity(0.8)
                                            Text(chatRoom.status != "end" ? Status.proceeding.rawValue : Status.end.rawValue)
                                                .font(.caption2)
                                                .foregroundColor(.white)
                                                .padding(.horizontal, 8)
                                                .padding(.vertical, 4)
                                                .background (
                                                    RoundedRectangle(cornerRadius: 12)
                                                        .fill(chatRoom.status != "end" ? .blue : Color(UIColor.systemGray4))
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
                                Text("대화를 시작해 보세요.")
                            }
                        }
                }
            }
            .listStyle(.plain)
            .padding(.horizontal, 8)
        }
    }
}
