//
//  ContentView.swift
//  BeerChat
//
//  Created by 허준혁 on 2023/07/10.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var pageManager = PageManager.shared
    var body: some View {
        switch pageManager.currentPage {
        case .splash:
            SplashView()
        case .entry:
            EntryView()
        case .keywordSelection:
            KeywordSelectionView()
        case .main:
            MainView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
