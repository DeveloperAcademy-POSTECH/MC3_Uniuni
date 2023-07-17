//
//  KeywordGridView.swift
//  BeerChat
//
//  Created by apple on 2023/07/16.
//

import SwiftUI

struct KeywordGridView: View {
    let keyword: [String]
    @Binding var seletedKewords: Set<String>
    @Binding var lastkeyword: String
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 2), spacing: 10) {
            ForEach(keyword, id: \.self) { word in
                VStack {
                    Button(action: {
                        if !seletedKewords.contains(word){
                            lastkeyword = word
                            seletedKewords.insert(lastkeyword)
                        } else {
                            seletedKewords.remove(word)
                        }
                    }) {
                        Text(word)
                            .font(.headline)
                            .padding(10)
                            .background(seletedKewords.contains(word) ? .blue : Color(cgColor: UIColor.lightGray.cgColor))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
            }
        }
    }
}

struct KeywordGridView_Previews: PreviewProvider {
    static var previews: some View {
        KeywordGridView(keyword: ["학점 4.0", "학점 3.0", "전과", "공대", "미대", "외국어대", "전자정보대"], seletedKewords: .constant([]), lastkeyword: .constant(""))
    }
}
