//
//  ChatRoomManager.swift
//  BeerChat
//
//  Created by Nayeon Kim on 2023/07/16.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct ChatRoom: Codable {
    @DocumentID var roomId: String?
    var questioner: String
    var respondent: String
    var status: String
    var recentMessage: DocumentReference?

    enum CodingKeys: String, CodingKey {
        case roomId
        case questioner
        case respondent
        case status
        case recentMessage
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        _roomId = try container.decode(DocumentID<String>.self, forKey: .roomId)
        questioner = try container.decode(String.self, forKey: .questioner)
        respondent = try container.decode(String.self, forKey: .respondent)
        status = try container.decode(String.self, forKey: .status)
        recentMessage = try container.decode(DocumentReference.self, forKey: .recentMessage)
        
        
//        recentMessageDocumentReference.getDocument() { (document, error) in
//            if let error = error {
//                print("Error converting document: \(error.localizedDescription)")
//            } else {
//                self?.recentMessage = try? document?.data(as: Message.self)
//            }
//        }
    }
    
    init(questioner: String, respondent: String, status: String, recentMessage: DocumentReference) {
        self.questioner = questioner
        self.respondent = respondent
        self.status = status
        self.recentMessage = recentMessage
    }
}

class FirestoreManager: ObservableObject {
    init() {
        self.fetchAllChatRooms()
    }
    private let database = Firestore.firestore()

    @Published var chatRooms = [ChatRoom]()
    @Published var matchingUsers = [User]()
    @Published var userKeywords = [String]()
    
    func resetAllData() {
        self.chatRooms.removeAll()
        self.userKeywords.removeAll()
        self.resetMatchingUsers()
    }

    func resetMatchingUsers() {
        self.matchingUsers.removeAll()
    }

    func fetchAllChatRooms() {
        database.collection("chatRoom")
            .whereField("questioner", isEqualTo: "iyNMs7XySOgBVmxNOS0lvkUlt6m2")
            .addSnapshotListener { (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    for document in querySnapshot!.documents {
                        print(document.description)
                        if let data = try? document.data(as: ChatRoom.self) {
                            print(data.questioner)
                            print(data.recentMessage!.description)
                        }
                    }
                    self.chatRooms = querySnapshot!.documents.compactMap { document in
                        try? document.data(as: ChatRoom.self)
                    }//.sorted(by: {$0.recentMessage.timestamp > $1.recentMessage.timestamp})
                }
            }
    }

    func fetchUsersByKeywords(matchingKeywords: [String]) {
        if matchingKeywords.isEmpty {
            return
        }
        database.collection("user").whereField("keywords", arrayContainsAny: matchingKeywords).getDocuments() { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    // print("\(document.documentID): \(document.data())")
                    if let user = try? document.data(as: User.self) {
                        self.matchingUsers.append(user)
                    }
                }
            }
        }
    }
//
//    func addChatRoom(userId: String, partnerId: String, roomName: String) {
//        let newChatRoom = ChatRoom(questioner: userId, respondent: partnerId, status: "pending", recentMessage: Message(uid: "temp", text: "temp", timestamp: Date()))
//        do {
//            let data = try Firestore.Encoder().encode(newChatRoom)
//            _ = try database.collection("chatRoom").addDocument(data: data)
//        } catch {
//            print("메시지 전송 에러: \(error.localizedDescription)")
//        }
//    }
}
