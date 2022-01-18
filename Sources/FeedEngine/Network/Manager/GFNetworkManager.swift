//
//  GFNetworkManager.swift
//  FeedEngine
//
//  Created by Abin Baby on 18/01/22.
//

import UIKit

class GFNetworkManager {

    static let sharedInstance: GFNetworkManager = GFNetworkManager()
    let cache: NSCache = NSCache<NSString, UIImage>()
    var decoder: JSONDecoder {
        let decoder: JSONDecoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }

    init() {}

    // MARK: - URLSession Data task

    func fetchData <T: Decodable>(from url: URL, completion: @escaping (Result<T, GFError>) -> Void) {

        let task: URLSessionTask = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completion(.failure(.networkError))
                return
            }

            guard let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode else {
                completion(.failure(.networkError))
                return
            }

            guard let data = data else {
                completion(.failure(.noData))
                return
            }

            do {
                let result: T = try self.decoder.decode(T.self, from: data)
                completion(.success(result))
            }catch{
                completion(.failure(.invalidData))
            }
        }

        task.resume()
    }

    // MARK: - Fetch image from URL or from cache

    func downloadImage(from urlString: String, completetion: @escaping (UIImage?) -> Void) {
        let cacheKey: NSString = NSString(string: urlString)

        if let image: UIImage = cache.object(forKey: cacheKey) {
            completetion(image)
            return
        }

        guard let url: URL = URL(string: urlString) else {
            completetion(nil)
            return
        }

        let task: URLSessionDataTask = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in

            guard let self = self,
                error == nil,
                let response = response as? HTTPURLResponse, response.statusCode == 200,
                let data = data,
                let image = UIImage(data: data) else {
                    completetion(nil)
                    return
                }

            self.cache.setObject(image, forKey: cacheKey)
            completetion(image)
        }

        task.resume()
    }
}
