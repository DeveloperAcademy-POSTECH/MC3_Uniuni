//
//  KeywordGridView.swift
//  BeerChat
//
//  Created by apple on 2023/07/16.
//

import SwiftUI

struct KeywordGridView: View {
    let keywords: [String]
    let fontSize: CGFloat = 17
    @Binding var seletedKewords: Set<String>
    @Binding var lastkeyword: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(getRows(), id: \.self) { rows in
                HStack {
                    ForEach(rows, id: \.self) { keyword in
                        tagView(tag: keyword)
                    }
                }
            }
        }
        .frame(width: UIScreen.main.bounds.width - 80, alignment: .leading)
    }
    
    @ViewBuilder
    func tagView(tag: String) -> some View {
        Button(action: {
            if !seletedKewords.contains(tag) {
                lastkeyword = tag
                seletedKewords.insert(lastkeyword)
            } else {
                seletedKewords.remove(tag)
            }
        }) {
            Text(tag)
                .font(.system(size: fontSize))
                .padding(10)
                .background(seletedKewords.contains(tag) ? .blue : Color(UIColor.systemGray4))
                .foregroundColor(.white)
                .cornerRadius(10)
        }
    }
 
    func getRows() -> [[String]] {
        var rows: [[String]] = []
        var currentRow: [String] = []
        
        var totalWidth: CGFloat = 0
        let screenWidth: CGFloat = UIScreen.main.bounds.width - 90
        
        keywords.forEach { keyword in
            totalWidth += (fontSize(text: keyword) + 30)
            
            if totalWidth > screenWidth {
                totalWidth = (!currentRow.isEmpty || rows.isEmpty ? fontSize(text: keyword) + 30 : 0)
                rows.append(currentRow)
                currentRow.removeAll()
                currentRow.append(keyword)
            } else {
                currentRow.append(keyword)
            }
        }
        
        if !currentRow.isEmpty {
            rows.append(currentRow)
            currentRow.removeAll()
        }
        
        return rows
    }
    
    func fontSize(text: String) -> CGFloat {
        let font = UIFont.systemFont(ofSize: fontSize)
        let attributes = [NSAttributedString.Key.font: font]
        let size = (text as NSString).size(withAttributes: attributes)
        
        return size.width
    }
}

struct KeywordGridView_Previews: PreviewProvider {
    static var previews: some View {
        KeywordGridView(keywords: ["애플 디벨로퍼아카데미", "네이버 부스트캠프", "우형 우아한테크코스", "크래프톤 정글", "삼성 SSAFY"], seletedKewords: .constant([]), lastkeyword: .constant(""))
    }
}
