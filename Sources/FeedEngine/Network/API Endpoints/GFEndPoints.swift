//
//  GFEndPoints.swift
//  FeedEngine
//
//  Created by Abin Baby on 18/01/22.
//

import Foundation

protocol NetworkConfigurable {
    var path: String { get }
    var queryItems: [URLQueryItem]? { get }
    var url: URL? { get }
}

struct GFEndpoint: NetworkConfigurable {
    let path: String
    var queryItems: [URLQueryItem]?
    var url: URL? {
        var components: URLComponents = URLComponents()
        components.scheme = "https"
        components.host = AppConfiguration.apiBaseURL
        components.path = path
        components.queryItems = queryItems

        return components.url
    }

    static func searchUsers(queryItems: [URLQueryItem]) -> GFEndpoint {
        GFEndpoint(
            path: "/search/users", queryItems: queryItems
        )
    }

    static func userInfo(for username: String) -> GFEndpoint {
        GFEndpoint(
            path: "/users/\(username)", queryItems: nil
        )
    }

    static func followersList(for username: String, queryItems: [URLQueryItem]) -> GFEndpoint {
        GFEndpoint(
            path: "/users/\(username)/followers", queryItems: queryItems
        )
    }
}
