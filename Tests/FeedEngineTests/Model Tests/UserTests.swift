//
//  FollowerTests.swift
//  GHFollowersTests
//
//  Created by Abin Baby on 02/01/21.
//

@testable import FeedEngine
import XCTest

class UserTests: XCTestCase {

    private let testLogin: String = "testLogin"
    private let testUrl: String = "www.test.com"

    func testUserInit() {
        let follower: User = User(login: testLogin, avatarUrl: testUrl)

        XCTAssertEqual(follower.login, testLogin)
        XCTAssertEqual(follower.avatarUrl, testUrl)
    }
}
