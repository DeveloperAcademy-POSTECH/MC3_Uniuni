//
//  KeywordListView.swift
//  BeerChat
//
//  Created by apple on 2023/07/16.
//

import SwiftUI

struct KeywordListView: View {
    @Binding var currentKeyword: Keyword?
    @Binding var seletedKewords: Set<String>
    @Binding var lastkeyword: String
    var body: some View {
        ScrollView {
            ForEach(Keyword.allCases, id: \.self) { keyword in
                VStack {
                    HStack {
                        Text(keyword.name)
                            .font(.headline.weight(.bold))
                        Spacer()
                        Image(systemName: "chevron.forward")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(25)
                    .background(keyword == currentKeyword ? Color(UIColor.systemGray) : Color(UIColor.systemGray4))
                    .cornerRadius(20)
                    .onTapGesture {
                        currentKeyword = keyword
                    }
                    if currentKeyword == keyword {
                        KeywordGridView(keywords: keyword.detail, seletedKewords: $seletedKewords, lastkeyword: $lastkeyword)
                    }
                }
            }
        }
    }
}

struct KeywordListView_Previews: PreviewProvider {
    static var previews: some View {
        KeywordListView(currentKeyword: .constant(nil), seletedKewords: .constant([]), lastkeyword: .constant(""))
    }
}
