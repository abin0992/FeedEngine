//
//  MockNetworkManager.swift
//  GHFollowersTests
//
//  Created by Abin Baby on 02/01/21.
//

import Foundation
@testable import FeedEngine
import XCTest

class MockNetworkManager: NetworkService {
    static let shared: MockNetworkManager = MockNetworkManager()

    func request<T>(endpoint: URL, completion: @escaping (Result<T, GFError>) -> Void) where T: Decodable {

        if let data: Data = try? Data(contentsOf: endpoint) {
            let decoder: JSONDecoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            decoder.dateDecodingStrategy = .iso8601
            do {
                let result: T = try decoder.decode(T.self, from: data)
                completion(.success(result))
            } catch {
                XCTFail("Reading contents of file json failed! (Exception: \(error))")
                completion(.failure(.urlGeneration))
            }
        } else {
            completion(.failure(.urlGeneration))
            XCTFail("could not load contents \(endpoint)")
        }
    }

    func downloadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        // TODO: Add test logic 
    }
}
