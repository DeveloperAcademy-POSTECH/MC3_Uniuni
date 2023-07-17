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

final class FirestoreManager: ObservableObject {
    static let shared = FirestoreManager()
    private init () {}

    private let database = Firestore.firestore()
    private var listener: ListenerRegistration?
    @Published var chatRooms = [ChatRoom]()
    @Published var recentChatRoomId: String?
    @Published var isChatOn: Bool = false
    
    func initChatRoom(userId: String, completion: @escaping (Bool) -> Void) {
        listener = database.collection("chatRoom")
            .whereField("questioner", isEqualTo: userId)
            .addSnapshotListener { (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                    completion(false)
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
                                    }
                                }
                            }
                            self.chatRooms.append(data)
                        }
                    }
                    completion(true)
                }
            }
    }
    /*
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
    }*/

    func addChatRoom(userId: String, partnerId: String, keyword: String, completion: @escaping (String?) -> Void) {
        let newChatRoom = ChatRoom(questioner: userId, respondent: partnerId, status: "pending", keyword: keyword)
        do {
            let data = try Firestore.Encoder().encode(newChatRoom)
            var ref: DocumentReference?
            ref = database.collection("chatRoom").addDocument(data: data) { error in
                if let error = error {
                    print("Error adding chatRoom: \(error)")
                } else {
                    guard let documentID = ref?.documentID else {
                                print("Error: Document ID is nil")
                                return
                            }
                    print(documentID)
                    self.recentChatRoomId = documentID
                    completion(self.recentChatRoomId)
                }
            }
        } catch {
            print("메시지 전송 에러: \(error.localizedDescription)")
            completion(nil)
        }
    }
    
    func updateRecentChatRoomId(chatRoomId: String, completion: @escaping (Bool) -> Void) {
        self.recentChatRoomId = chatRoomId
        completion(true)
    }
    
    func fetchChatRoom(chatRoomId: String, completion: @escaping (ChatRoom?) -> Void) {
        database.collection("user").document(chatRoomId).getDocument { (document, error) in
            if error != nil {
                print("Error reading the document: \(error.debugDescription)")
                completion(nil)
                return
            }
            if let document = document, document.exists {
                completion(try? document.data(as: ChatRoom.self))
            } else {
                print("Error reading the document: User Document does not exist")
            }
            completion(nil)
        }
    }
}
