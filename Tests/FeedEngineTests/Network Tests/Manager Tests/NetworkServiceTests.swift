//
//  NetworkServiceTests.swift
//  FeedEngineTests
//
//  Created by Abin Baby on 19/01/2022.
//

@testable import FeedEngine
import XCTest

class NetworkServiceTests: XCTestCase {

    let expectationName: String = "Feed service"
    var mockFeedService: GFService!

    override func setUp() {
        mockFeedService = GFService(networkManager: MockNetworkManager.shared,
                                    config: MockConfig.shared)
    }

    func testSearchUser() {
        let exp: XCTestExpectation = expectation(description: expectationName)

        mockFeedService.fetchUsers(for: "test", page: 00) { result in
            switch result {
            case .success:
                exp.fulfill()
            case .failure:
                XCTFail("Should return fetched users list")
            }
        }
         waitForExpectations(timeout: 0.1, handler: nil)
    }

    func testFetchUserInfo() {
        let exp: XCTestExpectation = expectation(description: expectationName)

        mockFeedService.fetchUserInfo(for: "testUser") { result in
            switch result {
            case .success:
                exp.fulfill()
            case .failure:
                XCTFail("Should return single user's information")
            }
        }
         waitForExpectations(timeout: 0.1, handler: nil)
    }

    func testFetchFollowers() {
        let exp: XCTestExpectation = expectation(description: expectationName)

        mockFeedService.fetchFollowers(for: "test", page: 00) { result in
            switch result {
            case .success:
                exp.fulfill()
            case .failure:
                XCTFail("Should return fetched followers list")
            }
        }
         waitForExpectations(timeout: 0.1, handler: nil)
    }
}
