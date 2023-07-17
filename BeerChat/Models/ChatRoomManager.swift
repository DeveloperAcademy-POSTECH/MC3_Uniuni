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
    // TODO: Array Index로 변경하기
    var keyword: String
    var recentMessage: Message?
    var recentMessageDocumentReference: DocumentReference?

    enum CodingKeys: String, CodingKey {
        case roomId
        case questioner
        case respondent
        case status
        case keyword
        case recentMessage
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        _roomId = try container.decode(DocumentID<String>.self, forKey: .roomId)
        questioner = try container.decode(String.self, forKey: .questioner)
        respondent = try container.decode(String.self, forKey: .respondent)
        status = try container.decode(String.self, forKey: .status)
        keyword = try container.decode(String.self, forKey: .keyword)
        recentMessageDocumentReference = try? container.decode(DocumentReference.self, forKey: .recentMessage)
    }
    
    init(questioner: String, respondent: String, status: String, keyword: String) {
        self.questioner = questioner
        self.respondent = respondent
        self.status = status
        self.keyword = keyword
    }
}

class FirestoreManager: ObservableObject {
    private let database = Firestore.firestore()
    private var listener: ListenerRegistration?
    @Published var chatRooms = [ChatRoom]()
    @Published var matchingUsers = [User]()
    @Published var userKeywords = [String]()
    
    func fetchChatRoom() {
        guard let currentUserId = UserManager.shared.currentUser?.userId else { return }
        database.collection("chatRoom")
            .whereField("questioner", isEqualTo: currentUserId)
            .addSnapshotListener { (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    self.chatRooms = []
                    for document in querySnapshot!.documents {
                        if var data = try? document.data(as: ChatRoom.self) {
                            if let recentMessageDocumentReference = data.recentMessageDocumentReference {
                                recentMessageDocumentReference.getDocument { (document, error) in
                                    if let error = error {
                                        print("Error : \(error.localizedDescription)")
                                    } else if let document = document, document.exists {
                                        data.recentMessage = try? document.data(as: Message.self)
                                        self.chatRooms.append(data)
                                        //                                    self.chatRooms = self.chatRooms.sorted(by: {$0.recentMessage!.timestamp > $1.recentMessage!.timestamp})
                                    }
                                }
                            } else {
                                self.chatRooms.append(data)
                            }
                        }
                    }
                }
            }
    }
    
    func resetAllData() {
        self.chatRooms.removeAll()
        self.userKeywords.removeAll()
        self.resetMatchingUsers()
    }

    func resetMatchingUsers() {
        self.matchingUsers.removeAll()
    }
    
    func fetchUsersByKeywords(matchingKeywords: [String]) {
        if matchingKeywords.isEmpty {
            return
        }
        database.collection("user").whereField("keywords", arrayContainsAny: matchingKeywords).getDocuments { (querySnapshot, error) in
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

    func addChatRoom(userId: String, partnerId: String, keyword: String, completion: @escaping (String?) -> Void) {
        let newChatRoom = ChatRoom(questioner: userId, respondent: partnerId, status: "pending", keyword: keyword)
        do {
            let data = try Firestore.Encoder().encode(newChatRoom)
            let ref = database.collection("chatRoom").addDocument(data: data)
            completion(ref.documentID)
        } catch {
            print("메시지 전송 에러: \(error.localizedDescription)")
            completion(nil)
        }
    }
}
