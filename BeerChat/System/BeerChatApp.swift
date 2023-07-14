//
//  BeerChatApp.swift
//  BeerChat
//
//  Created by 허준혁 on 2023/07/10.
//

import SwiftUI
import Firebase

@main
struct BeerChatApp: App {
    // Firebase initialization following SwiftUI Life Style. to be revised soon.
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
