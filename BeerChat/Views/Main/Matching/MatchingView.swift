//
//  MatchingView.swift
//  BeerChat
//
//  Created by Jun on 2023/07/14.
//

import SwiftUI

struct MatchingView: View {
    @State var selectedKeywords: Set<String> = []
    @State var lastKeyword: String = ""
    @State var isMatching: Bool = false
    @State var matchingUser: User?
    @State var currentKeyword: Keyword?
    @Binding var chatRoomId: String
    @Binding var pageIndex: Int
    var keywordCount: Int {
        selectedKeywords.count
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("질문할\n키워드 선택")
                .font(.title.weight(.bold))
            Spacer()
            KeywordListView(currentKeyword: $currentKeyword, seletedKewords: $selectedKeywords, lastkeyword: $lastKeyword)
                .onChange(of: keywordCount) { _ in
                    if keywordCount > 2 {
                        selectedKeywords.remove(lastKeyword)
                    }
                }
                .onChange(of: currentKeyword) { _ in
                    selectedKeywords.removeAll()
                }
            Button(action: {
                UserManager.shared.fetchUserKeyword(keywords: Array(selectedKeywords)) { user in
                    if let user = user {
                        guard let currentUserId = UserManager.shared.currentUser?.userId else { return }
                        self.matchingUser = user.filter { $0.userId != currentUserId }.randomElement()
                        self.isMatching = true
                    }
                }
            }) {
                Text("매칭!")
                    .font(.title2.weight(.bold))
                    .foregroundColor(Color.black)
                    .frame(height: 60)
                    .frame(maxWidth: .infinity)
                    .background(selectedKeywords.isEmpty ? Color(UIColor.systemGray4) : .blue)
                    .cornerRadius(11)
            }
            .disabled(selectedKeywords.isEmpty)
            .opacity(selectedKeywords.isEmpty ? 0.3 : 1)

        }
        .padding()
        .onChange(of: isMatching) { newValue in
            if !newValue {
                matchingUser = nil
            }
        }
        .fullScreenCover(isPresented: $isMatching) {
            if let matchingUser = self.matchingUser {
                MatchingProfileView(user: matchingUser, keyword: lastKeyword, isPresentedSheet: $isMatching, pageIndex: $pageIndex)
            }
        }
    }
}

struct MatchingView_Previews: PreviewProvider {
    static var previews: some View {
        MatchingView(chatRoomId: .constant(""), pageIndex: .constant(0))
    }
}
