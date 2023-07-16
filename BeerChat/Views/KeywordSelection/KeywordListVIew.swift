//
//  KeywordListVIew.swift
//  BeerChat
//
//  Created by apple on 2023/07/16.
//

import SwiftUI

struct KeywordListVIew: View {
    @State var currentKeyword: Keyword?
    @State var seletedKewords: Set<String> = []
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
                    .background(.gray)
                    .cornerRadius(20)
                    .onTapGesture {
                        currentKeyword = keyword
                    }
                    if currentKeyword == keyword {
                        ForEach(keyword.detail, id: \.self) { semiKeyword in
                            Button(action: { seletedKewords.insert(semiKeyword) }) {
                                Text(semiKeyword)
                                    .padding()
                                    .background(Color(cgColor: UIColor.lightGray.cgColor))
                                    .cornerRadius(10)
                            }
                        }
                    }
                }
            }
        }
        .padding()
    }
}

struct KeywordListVIew_Previews: PreviewProvider {
    static var previews: some View {
        KeywordListVIew()
    }
}
