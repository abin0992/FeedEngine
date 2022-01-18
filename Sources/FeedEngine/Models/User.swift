//
//  User.swift
//  FeedEngine
//
//  Created by Abin Baby on 18/01/22.
//

import Foundation

struct UserList: Codable, Hashable {
    let totalCount: Int
    let incompleteResults: Bool
    let items: [User]
}

struct User: Codable, Hashable {
    var identifier: String = UUID().uuidString
    let login: String
    let avatarUrl: String

    private enum CodingKeys: String, CodingKey {
        case login
        case avatarUrl
      }
    }
