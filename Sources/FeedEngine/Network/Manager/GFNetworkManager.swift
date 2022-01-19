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
    func downloadImage(from urlString: String, completion: @escaping (UIImage?) -> Void)
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
            fetchData(from: urlRequest) { responseData in
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

    // MARK: - Fetch image from URL or from cache

    func downloadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        let cacheKey: NSString = NSString(string: urlString)

        if let image: UIImage = cache.object(forKey: cacheKey) {
            completion(image)
            return
        }

        guard let url: URL = URL(string: urlString) else {
            self.logger.log(error: .urlGeneration)
            completion(nil)
            return
        }

        fetchData(from: URLRequest(url: url)) { responseData in
            switch responseData {
            case .success(let responseData):
                guard let image = UIImage(data: responseData) else {
                    self.logger.log(error: .invalidData)
                    completion(nil)
                    return
                }

                self.cache.setObject(image, forKey: cacheKey)
                completion(image)
            case .failure(let error):
                self.logger.log(error: error)
                completion(nil)
            }
        }
    }
}

class GFNetworkManager: NetworkSessionManager {

    static let sharedInstance: GFNetworkManager = GFNetworkManager()
    private let logger: NetworkErrorLogger
    private let cache: NSCache = NSCache<NSString, UIImage>()

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

    private func resolve(error: Error) -> GFError {
        let code = URLError.Code(rawValue: (error as NSError).code)
        switch code {
        case .notConnectedToInternet: return .notConnected
        default: return .generic
        }
    }
}
