//
//  User.swift
//  FeedEngine
//
//  Created by Abin Baby on 18/01/22.
//

import Foundation

public struct UserDetail: Codable {
    public let login: String
    public let avatarUrl: String
    public var name: String?
    public var location: String?
    public var bio: String?
    public let publicRepos: Int
    public let publicGists: Int
    public let htmlUrl: String
    public let following: Int
    public let followers: Int
    public let createdAt: Date
}
