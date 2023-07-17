//
//  MatchingProfileView.swift
//  BeerChat
//
//  Created by Yisak on 2023/07/17.
//

import SwiftUI

struct MatchingProfileView: View {
    var body: some View {
        VStack {
            Text("닉네임과의 \n대화 어때요?")
                .font(.system(size: 40, weight: .bold))
                .padding(.trailing, 150)
            Image("Profile")
                .padding(.top, 20)
                .padding(.bottom, 50)
            Text("#AppleDeveloperAcademy #개발")
                .font(.system(size: 20))
                .frame(width: 330, height: 70)
                .background(Color(.lightGray))
                .cornerRadius(20)
            Text("대화 내용")
                .font(.system(size: 20))
                .frame(width: 330, height: 150)
                .background(Color(.lightGray))
                .cornerRadius(20)
                .padding(.bottom, 25)
            HStack {
                Button {
                    // 거절
                } label: {
                    Text("거절")
                        .frame(width: 110, height: 30)
                }
                .buttonStyle(.bordered)
                .padding(.trailing, 50)
                Button {
                    // 수락
                } label: {
                    Text("수락")
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
        MatchingProfileView()
    }
}
