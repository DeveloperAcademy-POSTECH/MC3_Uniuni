//
//  MatchingProfileView.swift
//  BeerChat
//
//  Created by Yisak on 2023/07/17.
//

import SwiftUI

struct MatchingProfileView: View {
    let user: User
    let keyword: String
    @Binding var isPresentedSheet: Bool
    @Binding var chatRoomId: String
    @Binding var pageIndex: Int
    @EnvironmentObject var firestoreManager: FirestoreManager
    var body: some View {
        VStack(alignment: .leading) {
            Text("이 사람과\n대화 어때요?")
                .font(.title.weight(.bold))
                .padding(.bottom, 54)
            Image("DummyProfile")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
            VStack(spacing: 24) {
                Text("\(user.affiliation) (\(String(user.yearOfAdmission)))")
                    .font(.body.weight(.bold))
                    .padding(20)
                    .frame(maxWidth: .infinity)
                    .background(Color(UIColor.systemGray4))
                    .cornerRadius(20)
                Text("\(user.keywords.map { "#\($0)" }.joined(separator: " "))")
                    .font(.body.weight(.bold))
                    .padding(20)
                    .frame(maxWidth: .infinity)
                    .background(Color(UIColor.systemGray4))
                    .cornerRadius(20)
                Text(keyword)
                    .font(.body.weight(.bold))
                    .padding(20)
                    .frame(maxWidth: .infinity)
                    .background(Color(UIColor.systemGray4))
                    .cornerRadius(20)
            }
            .padding(.vertical, 36)
            HStack {
                Button {
                    isPresentedSheet = false
                } label: {
                    Text("거절하기")
                        .font(.body.weight(.bold))
                        .padding(.vertical, 16)
                        .padding(.horizontal, 52)
                        .background(Color(UIColor.systemGray4))
                        .cornerRadius(20)
                        .foregroundColor(.blue)
                }
                Spacer()
                Button {
                    guard let currentUserId = UserManager.shared.currentUser?.userId,
                          let partneruserId = user.userId else { return }
                    firestoreManager.addChatRoom(userId: currentUserId, partnerId: partneruserId, keyword: keyword) { complete in
                        guard let chatRoomId = complete else { return }
                        self.chatRoomId = chatRoomId
                    }

                    pageIndex = 1
                    isPresentedSheet = false
                } label: {
                    Text("수락하기")
                        .font(.body.weight(.bold))
                        .padding(.vertical, 16)
                        .padding(.horizontal, 52)
                        .background(.blue)
                        .cornerRadius(20)
                        .foregroundColor(.white)
                }
            }
        }
        .padding()
    }
}

struct MatchingProfileView_Previews: PreviewProvider {
    static var previews: some View {
        MatchingProfileView(user: User(affiliation: "애플아카데미", major: "개발", yearOfAdmission: 2018), keyword: "부트캠프", isPresentedSheet: .constant(true), chatRoomId: .constant(""), pageIndex: .constant(0))
    }
}
