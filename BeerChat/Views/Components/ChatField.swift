//
//  ChatField.swift
//  BeerChat
//
//  Created by Nayeon Kim on 2023/07/17.
//

import SwiftUI

struct ChatField: View {
    @EnvironmentObject var chatViewModel: ChatViewModel
    @State var messageText = ""
    
    var body: some View {
        ZStack {
            Color(.secondarySystemBackground)
                .ignoresSafeArea()
            ZStack(alignment: .trailing) {
                TextField("대화를 입력하세요.", text: $messageText)
                    .padding(12)
                    .padding(.trailing, 48)
                    .background(.white)
                    .cornerRadius(10)
                    .font(.subheadline)
                Button {
                    chatViewModel.sendMessage(messageText: messageText)
                    messageText = ""
                } label: {
                    Text("Send")
                        .fontWeight(.semibold)
                }
                .padding(.horizontal)
            }
            .padding(.horizontal, 16)
        }
    }
}

struct ChatField_Previews: PreviewProvider {
    static var previews: some View {
        ChatField()
    }
}
