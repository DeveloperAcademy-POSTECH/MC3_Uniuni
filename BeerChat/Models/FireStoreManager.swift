//
//  FireStoreManager.swift
//  BeerChat
//
//  Created by Nayeon Kim on 2023/07/16.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift


struct Message: Codable, Identifiable {
    @DocumentID var id: String?
    let uid: String
    let text: String
    let timestamp: Date

    enum CodingKeys: String, CodingKey {
        case id
        case uid
        case text
        case timestamp
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        _id = try container.decode(DocumentID<String>.self, forKey: .id)
        uid = try container.decode(String.self, forKey: .uid)
        text = try container.decode(String.self, forKey: .text)
        timestamp = try container.decode(Timestamp.self, forKey: .timestamp).dateValue()
    }

    init(uid: String, text: String, timestamp: Date) {
        self.uid = uid
        self.text = text
        self.timestamp = timestamp
    }
}

class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var newMessageText: String = ""

    private let database = Firestore.firestore()
    private var listener: ListenerRegistration?
    private var userId: String
    private var roomId: String
    
    init(roomId: String, userId: String) {
        self.userId = userId
        self.roomId = roomId

        listener = database.collection("chatRoom").document(roomId)
            .collection("messages")
            .order(by: "timestamp")
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("실시간 업데이트 에러: \(error.localizedDescription)")
                    return
                }

                guard let documents = snapshot?.documents else {
                    print("문서가 없습니다.")
                    return
                }

                self.messages = documents.compactMap { document in
                    try? document.data(as: Message.self)
                }
            }
    }

    func sendMessage(messageText: String) {
        let currentTime = Date()
        let newMessage = Message(uid: userId, text: messageText, timestamp: currentTime)
        do {
            let data = try Firestore.Encoder().encode(newMessage)
            _ = try database.collection("chatRoom").document(self.roomId).collection("messages").addDocument(data: data)
            _ = try database.collection("chatRoom").document(self.roomId).updateData(["timestamp" : currentTime])
//            newMessageText = ""
        } catch {
            print("메시지 전송 에러: \(error.localizedDescription)")
        }
    }
}
