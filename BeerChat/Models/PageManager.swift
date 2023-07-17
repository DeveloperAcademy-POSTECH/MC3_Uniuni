//
//  PageManager.swift
//  BeerChat
//
//  Created by Jun on 2023/07/14.
//

import Foundation

enum PageState {
    case emailVerify
    case entry
    case keywordSelection
    case main
}

final class PageManager: ObservableObject {
    static let shared = PageManager()
    private init () {}

    @Published var currentPage: PageState = .emailVerify
}
