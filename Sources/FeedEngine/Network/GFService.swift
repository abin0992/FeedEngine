//
//  GFService.swift
//  FeedEngine
//
//  Created by Abin Baby on 18/01/22.
//

import Foundation

class GFService {

    // MARK: User list API

    func fetchUsers(for searchKey: String, page: Int, completion: @escaping (Result<[User], GFError>) -> Void) {
        GFNetworkManager.sharedInstance.request(endpoint: FeedRouter.searchUsers(searchKey, page)) { (result: Result<UserList, GFError>) in
            switch result {
            case .success(let dataArray):
                completion(.success(dataArray.items))
            case .failure(let exception):
                completion(.failure(exception))
            }
        }
    }

    // MARK: User info API

    func fetchUserInfo(for username: String, completion: @escaping (Result<UserDetail, GFError>) -> Void) {
        GFNetworkManager.sharedInstance.request(endpoint: FeedRouter.userInfo(username)) { (result: Result<UserDetail, GFError>) in
            switch result {
            case .success(let user):
                completion(.success(user))
            case .failure(let exception):
                completion(.failure(exception))
            }
        }
    }

    // MARK: Followers List

    func fetchFollowers(for username: String, page: Int, completion: @escaping (Result<[User], GFError>) -> Void) {
        GFNetworkManager.sharedInstance.request(endpoint: FeedRouter.followersList(username, page)) { (result: Result<[User], GFError>) in
                switch result {
                case .success(let dataArray):
                    completion(.success(dataArray))
                case .failure(let exception):
                    completion(.failure(exception))
                }
            }
        }
}
