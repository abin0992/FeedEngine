//
//  GFEndPoints.swift
//  FeedEngine
//
//  Created by Abin Baby on 18/01/22.
//

import Foundation

protocol URLConfig {
    var url: URL { get }
}

private struct GFEndpoint: URLConfig {

    let path: String
    var queryItems: [URLQueryItem] = []
    var url: URL {
        var components: URLComponents = URLComponents()
        components.scheme = "https"
        components.host = AppConfiguration.apiBaseURL
        components.path = path
        components.queryItems = queryItems

        guard let url = components.url else {
            DLog("Invalid URL components: \(components)")
            preconditionFailure(
                "Invalid URL components: \(components)"
            )
        }

        return url
    }
}

protocol NetworkConfigurable {
    func searchUsers(with searchKey: String, page: Int) -> URLConfig
    func userInfo(for username: String) -> URLConfig
    func followersList(for username: String, page: Int) -> URLConfig
}

class GFUrlConfig: NetworkConfigurable {

    static let shared: GFUrlConfig = GFUrlConfig()

    func searchUsers(with searchKey: String, page: Int) -> URLConfig {
        GFEndpoint(
            path: "/search/users",
            queryItems: [
                URLQueryItem(name: "q", value: "\(searchKey)"),
                URLQueryItem(name: "per_page", value: "100"),
                URLQueryItem(name: "page", value: "\(page)")
            ]
        )
    }

    func userInfo(for username: String) -> URLConfig {
        GFEndpoint(
            path: "/users/\(username)"
        )
    }

    func followersList(for username: String, page: Int) -> URLConfig {
        GFEndpoint(
            path: "/users/\(username)/followers",
            queryItems: [
                URLQueryItem(name: "per_page", value: "100"),
                URLQueryItem(name: "page", value: "\(page)")
            ]
        )
    }
}
