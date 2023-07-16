//
//  KeywordSelectionView.swift
//  BeerChat
//
//  Created by Jun on 2023/07/14.
//

import SwiftUI

struct KeywordSelectionView: View {
    @State var seletedKewords: Set<String> = []
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("답변할\n키워드 선택")
                .font(.largeTitle.weight(.bold))
            KeywordListVIew(seletedKewords: $seletedKewords)
            Spacer()
            Button(action: {
                PageManager.shared.currentPage = .main
            }) {
                Text("확인")
                    .font(.title2.weight(.bold))
                    .foregroundColor(Color.white)
            }
            .frame(height: 60)
            .frame(maxWidth: .infinity)
            .background(.gray)
            .cornerRadius(11)
        }
        .padding()
    }
}

struct KeywordSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        KeywordSelectionView()
    }
}
