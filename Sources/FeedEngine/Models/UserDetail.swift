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
    
    public init(login: String, avatarUrl: String, name: String? = nil, location: String? = nil, bio: String? = nil, publicRepos: Int, publicGists: Int, htmlUrl: String, following: Int, followers: Int, createdAt: Date) {
        self.login = login
        self.avatarUrl = avatarUrl
        self.name = name
        self.location = location
        self.bio = bio
        self.publicRepos = publicRepos
        self.publicGists = publicGists
        self.htmlUrl = htmlUrl
        self.following = following
        self.followers = followers
        self.createdAt = createdAt
    }
}
