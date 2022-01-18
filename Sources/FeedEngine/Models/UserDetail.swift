//
//  User.swift
//  FeedEngine
//
//  Created by Abin Baby on 18/01/22.
//

import Foundation

struct UserDetail: Codable {
    let login: String
    let avatarUrl: String
    var name: String?
    var location: String?
    var bio: String?
    let publicRepos: Int
    let publicGists: Int
    let htmlUrl: String
    let following: Int
    let followers: Int
    let createdAt: Date
}
