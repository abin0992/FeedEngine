//
//  GFService.swift
//  FeedEngine
//
//  Created by Abin Baby on 18/01/22.
//

import UIKit
import Foundation

public class GFService: FeedServiceProtocol {

    private let networkManager: NetworkService
    private let config: NetworkConfigurable

    init(networkManager: NetworkService = GFNetworkManager.sharedInstance,
         config: NetworkConfigurable = GFUrlConfig.shared) {
        self.networkManager = networkManager
        self.config = config
    }

    public typealias RetrieveUsersResult = ((Result<[User], GFError>) -> Void)
    public typealias RetrieveUserInfoResult = ((Result<UserDetail, GFError>) -> Void)
    public typealias RetrieveFolllowersListResult = ((Result<[User], GFError>) -> Void)
    public typealias FetchImageCompletion = ((UIImage?) -> Void)

    // MARK: User list API

    public func fetchUsers(for searchKey: String, page: Int, completion: @escaping RetrieveUsersResult) {

        networkManager.request(endpoint: config.searchUsers(with: searchKey, page: page).url) { (result: Result<UserList, GFError>) in
            switch result {
            case .success(let dataArray):
                completion(.success(dataArray.items))
            case .failure(let exception):
                completion(.failure(exception))
            }
        }
    }

    // MARK: User info API

    public func fetchUserInfo(for username: String, completion: @escaping RetrieveUserInfoResult) {
        networkManager.request(endpoint: config.userInfo(for: username).url) { (result: Result<UserDetail, GFError>) in
            switch result {
            case .success(let user):
                completion(.success(user))
            case .failure(let exception):
                completion(.failure(exception))
            }
        }
    }

    // MARK: Followers List

    public func fetchFollowers(for username: String, page: Int, completion: @escaping RetrieveFolllowersListResult) {
        networkManager.request(endpoint: config.followersList(for: username, page: page).url) { (result: Result<[User], GFError>) in
            switch result {
            case .success(let dataArray):
                completion(.success(dataArray))
            case .failure(let exception):
                completion(.failure(exception))
            }
        }
    }

    // MARK: Fetch avatar image

    public func downloadImage(from urlString: String, completion: @escaping FetchImageCompletion) {
        networkManager.downloadImage(from: urlString) { image in
            if let image = image {
                completion(image)
            }
        }
    }
}

protocol FeedServiceProtocol {
    func fetchUsers(for searchKey: String, page: Int, completion: @escaping (Result<[User], GFError>) -> Void)
    func fetchUserInfo(for username: String, completion: @escaping (Result<UserDetail, GFError>) -> Void)
    func fetchFollowers(for username: String, page: Int, completion: @escaping (Result<[User], GFError>) -> Void)
    func downloadImage(from urlString: String, completion: @escaping (UIImage?) -> Void)
}
