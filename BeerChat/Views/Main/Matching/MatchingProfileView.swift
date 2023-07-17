//
//  MatchingProfileView.swift
//  BeerChat
//
//  Created by Yisak on 2023/07/17.
//

import SwiftUI

struct MatchingProfileView: View {
    let user: User
    @Binding var isPresentedSheet: Bool
    var body: some View {
        VStack(alignment: .leading) {
            Text("닉네임과의\n대화 어때요?")
                .font(.system(size: 40, weight: .bold))
                .padding(.bottom, 54)
            Image(systemName: "photo")
                .resizable()
                .frame(maxWidth: .infinity)
            VStack(spacing: 24) {
                Text("\(user.affiliation) (\(user.yearOfAdmission))")
                    .font(.body.weight(.bold))
                    .padding(20)
                    .frame(maxWidth: .infinity)
                    .background(Color(.lightGray))
                    .cornerRadius(20)
                Text("#AppleDeveloperAcademy #개발")
                    .font(.body.weight(.bold))
                    .padding(20)
                    .frame(maxWidth: .infinity)
                    .background(Color(.lightGray))
                    .cornerRadius(20)
                Text("대화 내용")
                    .font(.body.weight(.bold))
                    .padding(20)
                    .frame(maxWidth: .infinity)
                    .background(Color(.lightGray))
                    .cornerRadius(20)
            }
            .padding(.vertical, 36)
            HStack {
                Button {
                    isPresentedSheet = false
                } label: {
                    Text("거절하기")
                        .frame(width: 110, height: 30)
                }
                .buttonStyle(.bordered)
                Spacer()
                Button {
                    // 수락
                } label: {
                    Text("수락하기")
                        .frame(width: 110, height: 30)
                }
                .buttonStyle(.borderedProminent)

            }
        }
        .padding()
    }
}

struct MatchingProfileView_Previews: PreviewProvider {
    static var previews: some View {
        MatchingProfileView(user: User(affiliation: "애플아카데미", major: "개발", yearOfAdmission: 2018), isPresentedSheet: .constant(true))
    }
}
