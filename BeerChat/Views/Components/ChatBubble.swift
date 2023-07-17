//
//  ChatBubble.swift
//  BeerChat
//
//  Created by Nayeon Kim on 2023/07/17.
//

import SwiftUI

struct ChatBubble: View {
    var message: Message
    var userId: String
    
    var body: some View {
        VStack(alignment: message.uid != userId ? .leading : .trailing) {
            HStack {
                Text(message.text)
                    .padding(8)
                    .background(message.uid != userId ? Color(.systemGray6) : Color.blue)
                    .foregroundColor(message.uid != userId ? .black : .white)
                    .cornerRadius(10)
            }
            .frame(maxWidth: 300, alignment: message.uid != userId ? .leading : .trailing)
            
            Text("\(message.timestamp.formatted(.dateTime.hour().minute()))")
                .font(.caption2)
                .foregroundColor(.gray)
                .padding(message.uid != userId ? .leading : .trailing, 4)
        }
        .frame(maxWidth: .infinity, alignment: message.uid != userId ? .leading : .trailing)
        .padding(message.uid != userId ? .leading : .trailing)
        .padding(.horizontal, 12)
    }
}

// struct ChatBubble_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatBubble()
//    }
// }
