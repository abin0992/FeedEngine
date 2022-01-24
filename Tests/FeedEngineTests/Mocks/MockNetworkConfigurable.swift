//
//  MockNetworkConfigurable.swift
//  FeedEngineTests
//
//  Created by Abin Baby on 19/01/2022.
//

@testable import FeedEngine
import Foundation
import XCTest

private struct MockEndpoint: URLConfig {
    var url: URL
}

class MockConfig: NetworkConfigurable {

    static let shared: MockConfig = MockConfig()

    let testSearchUsersJSONFile: String = "test_searchUsers"
    let testFetchFollowersJSONFile: String = "test_fetchFollowers"
    let testUserInfoJSONFile: String = "test_userInfo"

    func searchUsers(with searchKey: String, page: Int) -> URLConfig {
        guard let jsonURL = Bundle(for: MockConfig.self).url(forResource: (testSearchUsersJSONFile), withExtension: "json") else {
             XCTFail("Loading file '\(testSearchUsersJSONFile).json' failed!")
            fatalError("Loading file '\(testSearchUsersJSONFile).json' failed!")
        }

        print(jsonURL)
        return MockEndpoint(url: jsonURL)
    }

    func userInfo(for username: String) -> URLConfig {
        guard let jsonURL = Bundle(for: MockConfig.self).url(forResource: (testUserInfoJSONFile), withExtension: "json") else {
            XCTFail("Loading file '\(testUserInfoJSONFile).json' failed!")
            fatalError("Loading file '\(testUserInfoJSONFile).json' failed!")
        }

        return MockEndpoint(url: jsonURL)
    }

    func followersList(for username: String, page: Int) -> URLConfig {
        guard let jsonURL = Bundle(for: MockConfig.self).url(forResource: (testFetchFollowersJSONFile), withExtension: "json") else {
            XCTFail("Loading file '\(testFetchFollowersJSONFile).json' failed!")
            fatalError("Loading file '\(testFetchFollowersJSONFile).json' failed!")
        }

        return MockEndpoint(url: jsonURL)
    }
}
