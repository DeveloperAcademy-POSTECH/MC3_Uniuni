//
//  EntryView.swift
//  BeerChat
//
//  Created by Jun on 2023/07/14.
//

import SwiftUI
import FirebaseAuth

struct EntryView: View {
    @FocusState private var isFocused: Bool
    @State private var afiliation: String = ""
    @State private var major: String = ""
    @State private var yearOfAdmission: Int = 2000
    @State private var userid: String = ""
    var body: some View {
        ZStack {
            TextField("학교", text: $afiliation)
            TextField("전공", text: $major)
            Picker("", selection: $yearOfAdmission) {
                let currentYear = Calendar.current.component(.year, from: Date())
                ForEach(2010...currentYear, id: \.self) {
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
        .onTapGesture {
            isFocused = false
        }
    }
}

struct EntryView_Previews: PreviewProvider {
    static var previews: some View {
        EntryView()
    }
}
