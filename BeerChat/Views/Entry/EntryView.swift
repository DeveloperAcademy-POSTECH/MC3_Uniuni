//
//  EntryView.swift
//  BeerChat
//
//  Created by Jun on 2023/07/14.
//

import SwiftUI

struct EntryView: View {
    var body: some View {
        VStack {
            Text("EntryView")
            Button("Next", action: {
                PageManager.shared.currentPage = .keywordSelection
            })
        }
    }
}

struct EntryView_Previews: PreviewProvider {
    static var previews: some View {
        EntryView()
    }
}
