//
//  UserManager.swift
//  BeerChat
//
//  Created by Jun on 2023/07/15.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct User: Codable {
    @DocumentID var userId: String?
    var iconIndex: Int
    var affiliation: String
    var major: String
    var yearOfAdmission: Int
    var keywords: [String]

    enum CodingKeys: String, CodingKey {
        case userId
        case iconIndex
        case affiliation
        case major
        case yearOfAdmission
        case keywords
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        _userId = try container.decode(DocumentID<String>.self, forKey: .userId)
        iconIndex = try container.decode(Int.self, forKey: .iconIndex)
        affiliation = try container.decode(String.self, forKey: .affiliation)
        major = try container.decode(String.self, forKey: .major)
        yearOfAdmission = try container.decode(Int.self, forKey: .yearOfAdmission)
        keywords = try container.decode([String].self, forKey: .keywords)
    }

    init(affiliation: String, major: String, yearOfAdmission: Int) {
        self.iconIndex = Int.random(in: 0...4)
        self.affiliation = affiliation
        self.major = major
        self.yearOfAdmission = yearOfAdmission
        self.keywords = [""]
    }
}

final class UserManager {
    static let shared = UserManager()
    private init () {}

    private let database = Firestore.firestore()

    @Published private(set) var currentUser: User?

    func signOut() {
        self.currentUser = nil
    }

    func addUser(documentId: String, user: User, completion: @escaping (Bool) -> Void) {
        do {
            let data = try Firestore.Encoder().encode(user)
            database.collection("user").document(documentId).setData(data) { error in
                if let error = error {
                    print("Error adding user: \(error.localizedDescription)")
                    completion(false)
                } else {
                    self.fetchCurrentUser(userId: documentId) { _ in
                        completion(true)
                    }
                }
            }
        } catch {
            print("Error adding user: \(error.localizedDescription)")
            completion(false)
        }
    }

    func updateUser(user: User, completion: @escaping (Bool) -> Void) {
        if let userId = user.userId {
            do {
                let data = try Firestore.Encoder().encode(user)
                database.collection("user").document(userId).setData(data) { error in
                    if let error = error {
                        print("Error updating user: \(error.localizedDescription)")
                        completion(false)
                    } else {
                        self.fetchCurrentUser(userId: userId) { _ in
                            completion(true)
                        }
                    }
                }
            } catch {
                print("Error updating user: \(error.localizedDescription)")
                completion(false)
            }
        } else {
            print("Error updating user: userId does not exist")
            completion(false)
        }
    }

    func fetchCurrentUser(userId: String, completion: @escaping (User?) -> Void) {
        database.collection("user").document(userId).getDocument { (document, error) in
            if error != nil {
                print("Error reading the document: \(error.debugDescription)")
                completion(nil)
                return
            }
            if let document = document, document.exists {
                self.currentUser = try? document.data(as: User.self)
            } else {
                self.currentUser = nil
                print("Error reading the document: User Document does not exist")
            }
            completion(self.currentUser)
        }
    }
    
    func fetchUserKeyword(keywords: [String], completion: @escaping ([User]?) -> Void) {
        database.collection("user").whereField("keywords", arrayContainsAny: keywords).getDocuments { (querySnapshot, error) in
            if error != nil {
                print("Error reading the document \(error.debugDescription)")
                completion(nil)
            }
            
            var users: [User] = []
            
            if let documents = querySnapshot?.documents {
                for document in documents {
                    if let user = try? document.data(as: User.self) {
                        users.append(user)
                    }
                }
            } else {
                print("User Document does not exist")
            }
            completion(users)
        }
    }
}
