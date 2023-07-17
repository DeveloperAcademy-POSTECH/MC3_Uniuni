//
//  BeerChatApp.swift
//  BeerChat
//
//  Created by 허준혁 on 2023/07/10.
//

import SwiftUI
import Firebase
import FirebaseAuth

@main
struct BeerChatApp: App {
    // Firebase initialization following SwiftUI Life Style. to be revised soon.
    init() {
        FirebaseApp.configure()
        UserManager.shared.fetchCurrentUser(userId: "iyNMs7XySOgBVmxNOS0lvkUlt6m2", completion: { user in
            if (user?.userId) != nil {
                PageManager.shared.currentPage = .main
            }
        })
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
