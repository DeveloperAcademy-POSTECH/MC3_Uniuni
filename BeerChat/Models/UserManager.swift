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
}

final class UserManager {
    static let shared = UserManager()
    private init () {}

    private let database = Firestore.firestore()

    @Published private(set) var currentUser: User?

    func addUser(user: User) {
        do {
            let data = try Firestore.Encoder().encode(user)
            database.collection("user").addDocument(data: data)
        } catch {
            print("Error adding user: \(error.localizedDescription)")
        }
    }

    func updateUser(user: User) {
        if let userId = user.userId {
            do {
                let data = try Firestore.Encoder().encode(user)
                database.collection("user").document(userId).setData(data)
            } catch {
                print("Error updating user: \(error.localizedDescription)")
            }
        } else {
            print("Error updating user: userId does not exist")
        }
    }

    func fetchCurrentUser(userId: String) {
        database.collection("user").document(userId).getDocument { (document, error) in
            if error != nil {
                print("Error reading the document \(error.debugDescription)")
                return
            }
            if let document = document, document.exists {
                self.currentUser = try? document.data(as: User.self)
            } else {
                print("User Document does not exist")
            }
        }
    }
}
