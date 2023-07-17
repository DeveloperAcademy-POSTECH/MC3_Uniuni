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
        if let uid = Auth.auth().currentUser?.uid {
            UserManager.shared.fetchCurrentUser(userId: uid, completion: { user in
                if let userid = user?.userId {
                    FirestoreManager.shared.initChatRoom(userId: userid) { isSuccess in
                        if isSuccess {
                            PageManager.shared.currentPage = .main
                        }
                    }
                }
            })
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
