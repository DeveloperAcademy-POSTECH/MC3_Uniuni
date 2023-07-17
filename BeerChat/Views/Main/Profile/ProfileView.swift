//
//  ProfileView.swift
//  BeerChat
//
//  Created by Jun on 2023/07/14.
//

import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    var body: some View {
        VStack {
            if let user = UserManager.shared.currentUser, let uid = user.userId {
                Text(uid)
                Text(user.affiliation)
                Text(user.major)
                Text(user.yearOfAdmission.description)
                Text(user.keywords.description)
            }
            Text("ProfileView")
            Button("Logout") {
                do {
                    try Auth.auth().signOut() // Auth.auth().signOut() 메서드 호출
                    UserManager.shared.signOut()
                    PageManager.shared.currentPage = .emailVerify
                } catch let signOutError as NSError {
                    print("Error signing out: \(signOutError)")
                }
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
