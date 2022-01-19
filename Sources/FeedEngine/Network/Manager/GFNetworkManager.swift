//
//  GFNetworkManager.swift
//  FeedEngine
//
//  Created by Abin Baby on 18/01/22.
//

import UIKit

protocol NetworkSessionManager {
    typealias CompletionHandler = (Result<Data, GFError>) -> Void

    func fetchData(from request: URLRequest, completion: @escaping CompletionHandler)
}

protocol NetworkService {
    func request<T: Decodable>(endpoint: Requestable, completion: @escaping (Result<T, GFError>) -> Void)
}

extension GFNetworkManager: NetworkService {

    var decoder: JSONDecoder {
        let decoder: JSONDecoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }

    func request<T: Decodable>(endpoint: Requestable, completion: @escaping (Result<T, GFError>) -> Void) {
        do {
            let urlRequest = try endpoint.asURLRequest()
            return fetchData(from: urlRequest) { responseData in
                switch responseData {
                case .success(let responseData):
                    do {
                        let result: T = try self.decoder.decode(T.self, from: responseData)
                        completion(.success(result))
                    } catch {
                        completion(.failure(.invalidData))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } catch {
            completion(.failure(.urlGeneration))
        }
    }
}

class GFNetworkManager: NetworkSessionManager {

    private let logger: NetworkErrorLogger

    static let sharedInstance: GFNetworkManager = GFNetworkManager()
    let cache: NSCache = NSCache<NSString, UIImage>()

    init(logger: NetworkErrorLogger = DefaultNetworkErrorLogger()) {
        self.logger = logger
    }

    internal func fetchData(from request: URLRequest, completion: @escaping (Result<Data, GFError>) -> Void) {
        let sessionDataTask = URLSession.shared.dataTask(with: request) { data, response, requestError in
            if let requestError = requestError {
                var error: GFError
                if let response = response as? HTTPURLResponse {
                    error = .GFError(statusCode: response.statusCode, data: data)
                } else {
                    error = self.resolve(error: requestError)
                }

                self.logger.log(error: error)
                completion(.failure(error))
            } else {

                guard let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode else {
                    completion(.failure(.networkError))
                    return
                }

                guard let data = data else {
                    completion(.failure(.noData))
                    return
                }

                self.logger.log(responseData: data, response: response)
                completion(.success(data))
            }
        }
        sessionDataTask.resume()
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

    private func resolve(error: Error) -> GFError {
        let code = URLError.Code(rawValue: (error as NSError).code)
        switch code {
        case .notConnectedToInternet: return .notConnected
        default: return .generic
        }
    }
}
