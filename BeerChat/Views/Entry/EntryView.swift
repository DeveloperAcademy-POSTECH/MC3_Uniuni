//
//  EntryView.swift
//  BeerChat
//
//  Created by Jun on 2023/07/14.
//

import SwiftUI
import FirebaseAuth

struct EntryView: View {
    enum FocusedField {
        case affiliation, major
    }

    @FocusState private var focusedField: FocusedField?
    @StateObject private var keyboardManager = KeyboardManager()
    @State private var afiliation: String = ""
    @State private var major: String = ""
    @State private var yearOfAdmission: Int = 2000
    @State private var userid: String = ""
    var body: some View {
        GeometryReader { geo in
            ZStack {
                VStack {
                    // Text(Auth.auth().currentUser?.email ?? "email")
                    VStack {
                        HStack {
                            Text("학교를 입력해주세요.")
                                .font(.title2)
                                .bold()
                            Spacer()
                        }
                        TextField("학교", text: $afiliation)
                            .font(.title3)
                            .padding(.top, 20)
                            .autocapitalization(.none)
                            .keyboardType(.emailAddress)
                            .disableAutocorrection(true)
                            .focused($focusedField, equals: .affiliation)
                        Divider()
                            .frame(height: 1)
                            .background(focusedField == .affiliation ? .blue : .gray.opacity(0.5))
                    }
                    .padding(.bottom, 40)
                    VStack {
                        HStack {
                            Text("전공을 입력해주세요.")
                                .font(.title2)
                                .bold()
                            Spacer()
                        }
                        TextField("전공", text: $major)
                            .font(.title3)
                            .padding(.top, 20)
                            .autocapitalization(.none)
                            .keyboardType(.emailAddress)
                            .disableAutocorrection(true)
                            .focused($focusedField, equals: .major)
                        Divider()
                            .frame(height: 1)
                            .background(focusedField == .major ? .blue : .gray.opacity(0.5))
                    }
                    .padding(.bottom, 40)
                    VStack {
                        HStack {
                            Text("입학년도를 입력해주세요.")
                                .font(.title2)
                                .bold()
                            Spacer()
                        }
                        Picker("입학년도", selection: $yearOfAdmission) {
                            let currentYear = Calendar.current.component(.year, from: Date())
                            ForEach((2010...currentYear).reversed(), id: \.self) {
                                Text(String($0))
                            }
                        }
                        .pickerStyle(.menu)
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
                        Text("회원가입")
                            .font(.body)
                            .bold()
                            .foregroundColor(.white)
                    }
                    .position(x: geo.size.width / 2, y: geo.size.height - 55 / 2)
                    .onTapGesture {
                        let user = User(affiliation: afiliation, major: major, yearOfAdmission: yearOfAdmission)
                        if let documentId = Auth.auth().currentUser?.uid {
                            UserManager.shared.addUser(documentId: documentId, user: user) { isSuccess in
                                if isSuccess {
                                    print("회원가입 성공")
                                    FirestoreManager.shared.initChatRoom(userId: userid) { isSuccessInitChatRoom in
                                        if isSuccessInitChatRoom {
                                            PageManager.shared.currentPage = .keywordSelection
                                        }
                                    }
                                } else {
                                    print("회원가입 실패")
                                }
                            }
                        }
                    }
            }
            .onTapGesture {
                focusedField = nil
            }
        }
    }
}

struct EntryView_Previews: PreviewProvider {
    static var previews: some View {
        EntryView()
    }
}
