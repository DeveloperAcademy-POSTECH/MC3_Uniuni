//
//  KeywordSelectionView.swift
//  BeerChat
//
//  Created by Jun on 2023/07/14.
//

import SwiftUI

struct KeywordSelectionView: View {
    var body: some View {
        VStack {
            Text("KeywordSelectionView")
            Button("Next", action: {
                PageManager.shared.currentPage = .main
            })
        }
    }
}

struct KeywordSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        KeywordSelectionView()
    }
}
