//
//  ProfileView.swift
//  BeerChat
//
//  Created by Jun on 2023/07/14.
//

import SwiftUI

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
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
