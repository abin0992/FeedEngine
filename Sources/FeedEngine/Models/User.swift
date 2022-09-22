//
//  User.swift
//  FeedEngine
//
//  Created by Abin Baby on 18/01/22.
//

import Foundation

public struct UserList: Codable, Hashable {
    let totalCount: Int
    let incompleteResults: Bool
    let items: [User]
    
    public init(totalCount: Int, incompleteResults: Bool, items: [User]) {
        self.totalCount = totalCount
        self.incompleteResults = incompleteResults
        self.items = items
    }
}

public struct User: Codable, Hashable {
    var identifier: String = UUID().uuidString
    public let login: String
    public let avatarUrl: String

    public init(identifier: String, login: String, avatarUrl: String) {
        self.identifier = identifier
        self.login = login
        self.avatarUrl = avatarUrl
    }

    private enum CodingKeys: String, CodingKey {
        case login
        case avatarUrl
      }
    }
