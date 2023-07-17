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
    @Binding var isMatching: Bool
    @Binding var matchingUser: User?
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
            } ) {
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
    }
}

struct MatchingView_Previews: PreviewProvider {
    static var previews: some View {
        MatchingView(isMatching: .constant(false), matchingUser: .constant(nil))
    }
}
