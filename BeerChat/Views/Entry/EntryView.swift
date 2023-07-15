//
//  EntryView.swift
//  BeerChat
//
//  Created by Jun on 2023/07/14.
//

import SwiftUI
import FirebaseAuth

struct EntryView: View {
    @State private var afiliation: String = ""
    @State private var major: String = ""
    @State private var yearOfAdmission: Int = 2000
    @State private var email: String = ""
    @State private var isEmailVerified: Bool = false
    @State private var userid: String = ""
    var body: some View {
        VStack {
            Text("EntryView")
            TextField("이메일 입력", text: $email)
                .padding()
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
                .disableAutocorrection(true)
            Button(action: {
                sendSignInLink()
            }, label: {
                Text("로그인 이메일 보내기")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            })
            if isEmailVerified {
                TextField("학교", text: $afiliation)
                TextField("전공", text: $major)
                Picker("", selection: $yearOfAdmission) {
                            ForEach(2000...2020, id: \.self) {
                                Text(String($0))
                            }
                        }
                        .pickerStyle(InlinePickerStyle())
                Button("회원가입", action: {
                    let user = User(affiliation: afiliation, major: major, yearOfAdmission: yearOfAdmission)
                    UserManager.shared.addUser(documentId: userid, user: user) { isSuccess in
                        if isSuccess {
                            print("회원가입 성공")
                            PageManager.shared.currentPage = .keywordSelection
                        } else {
                            print("회원가입 실패")
                        }
                    }
                })
            }
        }
        .onOpenURL { link in
            if Auth.auth().isSignIn(withEmailLink: link.absoluteString) {
                Auth.auth().signIn(withEmail: email, link: link.absoluteString) { user, error in
                    if let error = error {
                        print(error)
                    } else {
                        if let uid = user?.user.uid {
                            UserManager.shared.fetchCurrentUser(userId: uid) { currentUser in
                                if currentUser == nil {
                                    isEmailVerified = true
                                    self.userid = uid
                                } else {
                                    PageManager.shared.currentPage = .main
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    private func sendSignInLink() {
        let actionCodeSettings = ActionCodeSettings()
        actionCodeSettings.handleCodeInApp = true
        actionCodeSettings.url = URL(string: "https://beerchat.page.link/emailAuth")
        actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)
        Auth.auth().sendSignInLink(toEmail: email, actionCodeSettings: actionCodeSettings) { error in
            if let error = error {
                print("로그인 이메일 보내기 실패:", error.localizedDescription)
            } else {
                print("로그인 이메일 보냄")
            }
        }
    }

}

struct EntryView_Previews: PreviewProvider {
    static var previews: some View {
        EntryView()
    }
}
