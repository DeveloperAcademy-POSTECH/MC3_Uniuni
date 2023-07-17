//
//  EmailVerifyView.swift
//  BeerChat
//
//  Created by Jun on 2023/07/16.
//

import SwiftUI
import FirebaseAuth

struct EmailVerifyView: View {
    @StateObject private var keyboardManager = KeyboardManager()
    @State private var email: String = ""
    @State private var userid: String = ""
    @State private var isEmailVerified: Bool = false
    @State private var isEmailVerifying: Bool = false
    @State private var isEmailResending: Bool = false
    @State private var isEmailValid: Bool = true
    @FocusState private var isFocused: Bool
    var body: some View {
        GeometryReader { geo in
            ZStack {
                VStack {
                    HStack {
                        Text("이메일을 입력해주세요.")
                            .font(.title)
                            .bold()
                        Spacer()
                    }
                    TextField("이메일", text: $email)
                        .font(.title3)
                        .padding(.top, 20)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                        .disableAutocorrection(true)
                        .focused($isFocused)
                    Divider()
                        .frame(height: 1)
                        .background(isEmailValid ? (isFocused ? .blue : .gray.opacity(0.5)) : .red)
                    if !isEmailValid {
                        Text("이메일을 확인해주세요")
                            .font(.callout)
                            .foregroundColor(.red)
                    }
                    Spacer()
                }
                .padding(.horizontal, 22)
                .padding(.vertical, 42)
                Rectangle()
                    .foregroundColor(.blue)
                    .cornerRadius(keyboardManager.isKeyboardActive ? 0 : 10)
                    .frame(width: keyboardManager.isKeyboardActive ? geo.size.width : 353, height: 55)
                    .overlay {
                        Text(isEmailResending ? "재전송" : "확인")
                            .font(.body)
                            .bold()
                            .foregroundColor(.white)
                    }
                    .position(x: geo.size.width / 2, y: geo.size.height - 55 / 2)
                    .onTapGesture {
                        if self.textFieldValidatorEmail(self.email) {
                            self.isEmailValid = true
                            sendSignInLink(email: email) { isEmailSend in
                                if isEmailSend {
                                    isEmailVerifying = true
                                }
                            }
                        } else {
                            self.isEmailValid = false
                        }
                    }
            }
            .onTapGesture {
                isFocused = false
            }
            .alert("이메일 인증", isPresented: $isEmailVerifying) {
                Button("Ok") { isEmailResending = true }
            } message: {
                Text(isEmailResending ? "이메일을 재전송 했습니다.\n스팸메일함을 확인해보세요." : "이메일을 확인해주세요.")
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
                                        PageManager.shared.currentPage = .entry
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
    }

    func textFieldValidatorEmail(_ string: String) -> Bool {
        if string.count > 100 {
            return false
        }
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: string)
    }

    private func sendSignInLink(email: String, completion: @escaping (Bool) -> Void) {
        let actionCodeSettings = ActionCodeSettings()
        actionCodeSettings.handleCodeInApp = true
        actionCodeSettings.url = URL(string: "https://beerchat.page.link/emailAuth")
        actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)
        Auth.auth().sendSignInLink(toEmail: email, actionCodeSettings: actionCodeSettings) { error in
            if let error = error {
                print("Error sending email:", error.localizedDescription)
                completion(false)
            } else {
                completion(true)
            }
        }
    }
}

struct EmailVerifyView_Previews: PreviewProvider {
    static var previews: some View {
        EmailVerifyView()
    }
}
