//
//  User.swift
//  FeedEngine
//
//  Created by Abin Baby on 18/01/22.
//

import Foundation

// MARK: - UserList

public struct UserList: Codable, Hashable {
    public let totalCount: Int
    public let incompleteResults: Bool
    public let items: [User]
}

// MARK: - User

public struct User: Codable, Hashable {
    public var identifier: String = UUID().uuidString
    public let login: String
    public let avatarURL: String

    private enum CodingKeys: String, CodingKey {
        case login
        case avatarURL
    }
}
