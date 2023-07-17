//
//  KeywordSelectionView.swift
//  BeerChat
//
//  Created by Jun on 2023/07/14.
//

import SwiftUI
import FirebaseAuth

struct KeywordSelectionView: View {
    @State var seletedKewords: Set<String> = []
    @State var currentKeyword: Keyword?
    @State var lastkeyword: String = ""
    var keywordCount: Int {
        seletedKewords.count
    }
    var body: some View {
        VStack(alignment: .leading) {
            Text("답변할\n키워드 선택")
                .font(.title.weight(.bold))
            KeywordListView(currentKeyword: $currentKeyword, seletedKewords: $seletedKewords, lastkeyword: $lastkeyword)
                .onChange(of: keywordCount) { _ in
                    if keywordCount > 5 {
                        seletedKewords.remove(lastkeyword)
                    }
                }
            Spacer()
            Button(action: {
                guard let currentUserId = UserManager.shared.currentUser?.userId else { return }
                UserManager.shared.fetchCurrentUser(userId: currentUserId) { user in
                    if let user = user {
                        var newUser: User = user
                        newUser.keywords = Array(seletedKewords)
                        UserManager.shared.updateUser(user: newUser) { complete in
                            switch complete {
                            case true:
                                PageManager.shared.currentPage = .main
                            case false:
                                print("실패했다 생키야")
                            }
                        }
                    }
                }
            }) {
                Text("확인")
                    .font(.title2.weight(.bold))
                    .foregroundColor(Color.white)
                    .frame(height: 60)
                    .frame(maxWidth: .infinity)
                    .background(seletedKewords.isEmpty ? Color(UIColor.systemGray4) : .blue)
                    .cornerRadius(11)
            }
            .disabled(seletedKewords.isEmpty)
            .opacity(seletedKewords.isEmpty ? 0.3 : 1)
        }
        .padding(20)
    }
}

struct KeywordSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        KeywordSelectionView()
    }
}
