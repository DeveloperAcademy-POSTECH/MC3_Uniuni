//
//  MatchingView.swift
//  BeerChat
//
//  Created by Jun on 2023/07/14.
//

import SwiftUI

struct MatchingView: View {
    @State var seletedKeywords: Set<String> = []
    @State var lastKeyword: String = ""
    @State var isMatching: Bool = false
    @State var matchingUser: User?
    @Binding var chatRoomId: String
    @Binding var pageIndex: Int
    var keywordCount: Int {
        seletedKeywords.count
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("질문할\n키워드 선택")
                .font(.largeTitle.weight(.bold))
            Spacer()
            KeywordListView(seletedKewords: $seletedKeywords, lastkeyword: $lastKeyword)
                .onChange(of: keywordCount) { _ in
                    if keywordCount > 2 {
                        seletedKeywords.remove(lastKeyword)
                    }
                }
            Button(action: {
                UserManager.shared.fetchUserKeyword(keywords: Array(seletedKeywords)) { user in
                    if let user = user {
                        self.matchingUser = user.filter { $0.userId != "iyNMs7XySOgBVmxNOS0lvkUlt6m2"}.randomElement()
                        self.isMatching = true
                    }
                }
            }) {
                Text("확인")
                    .font(.title2.weight(.bold))
                    .foregroundColor(Color.white)
            }
            .disabled(seletedKeywords.isEmpty)
            .frame(height: 60)
            .frame(maxWidth: .infinity)
            .background(seletedKeywords.isEmpty ? .gray : .blue)
            .cornerRadius(11)
        }
        .padding()
        .onChange(of: isMatching) { newValue in
            if !newValue {
                matchingUser = nil
            }
        }
        .fullScreenCover(isPresented: $isMatching) {
            if let matchingUser = self.matchingUser {
                MatchingProfileView(user: matchingUser, isPresentedSheet: $isMatching, chatRoomId: $chatRoomId, pageIndex: $pageIndex)
            }
        }
    }
}

struct MatchingView_Previews: PreviewProvider {
    static var previews: some View {
        MatchingView(chatRoomId: .constant(""), pageIndex: .constant(0))
    }
}
