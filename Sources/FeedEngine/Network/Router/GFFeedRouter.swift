//
//  GFFeedRouter.swift
//  FeedEngine
//
//  Created by Abin Baby on 19/01/2022.
//

import Foundation

protocol Requestable {
    func asURLRequest() throws -> URLRequest
}

enum FeedRouter: Requestable {

    case searchUsers(String, Int)
    case userInfo(String)
    case followersList(String, Int)

    var method: HTTPMethodType {
      switch self {
      case .searchUsers, .userInfo, .followersList:
        return .get
      }
    }

    func asURLRequest() throws -> URLRequest {
        var url: URL!

        switch self {
        case let .searchUsers(username, page):
            let queryItems: [URLQueryItem] = configureSearchUserQueryItems(with: username, page: page)
            url = GFEndpoint.searchUsers(queryItems: queryItems).url
        case let .userInfo(username):
            url = GFEndpoint.userInfo(for: username).url
        case let .followersList(username, page):
            let queryItems: [URLQueryItem] = configureFollowerListQueryItems(page: page)
            url = GFEndpoint.followersList(for: username, queryItems: queryItems).url
        }

        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.timeoutInterval = TimeInterval(30)

        return request
    }

    // MARK: - Search user query items
    private func configureSearchUserQueryItems(with searchKey: String, page: Int) -> [URLQueryItem] {
        [
            URLQueryItem(name: "q", value: "\(searchKey)"),
            URLQueryItem(name: "per_page", value: "100"),
            URLQueryItem(name: "page", value: "\(page)")
        ]
    }

    private func configureFollowerListQueryItems(page: Int) -> [URLQueryItem] {
        [
            URLQueryItem(name: "per_page", value: "100"),
            URLQueryItem(name: "page", value: "\(page)")
        ]
    }
}

enum HTTPMethodType: String {
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
}
