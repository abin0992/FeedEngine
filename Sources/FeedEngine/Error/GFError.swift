//
//  GFError.swift
//  FeedEngine
//
//  Created by Abin Baby on 18/01/22.
//

import Foundation

enum GFError: Error {

    case invalidUsername
    case unableToComplete
    case invalidResponse
    case invalidData
    case limitExceeded
    case networkError
    case noData
    case urlGeneration
    case GFError(statusCode: Int, data: Data?)
    case notConnected
    case generic

    var description: String {
            switch self {
            case .invalidUsername:
                return "This username created an invalid request. Please try again."
            case .unableToComplete:
                return "Unable to complete your request. Please check your internet connection"
            case .invalidResponse:
                return "Invalid response from the server. Please try again."
            case .invalidData:
                return "The data received from the server was invalid. Please try again."
            case .limitExceeded:
                return "Github API rate limit exceeded. Wait for 60 seconds and try again."
            case .networkError:
                return "Could not complete operation due to nerwork error. Please try again."
            case .noData:
                return "No data received from server. Please try again"
            case .urlGeneration:
                return "Couldn't generate URL"
            case .GFError(statusCode: let statusCode, data: _):
                return "\(statusCode) error received."
            case .notConnected:
                return "Not connected to internet"
            case .generic:
                return "Sorry, something went wrong"
            }
        }
}
