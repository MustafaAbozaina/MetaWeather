//
//  NetworkError.swift
//  MetaWeatherFeed
//
//  Created by mustafa salah eldin on 2/10/22.
//

import Foundation


protocol NetworkError: Error {
    func errorDescription() -> String
}

enum RequesetDataError:  NetworkError {
    func errorDescription() -> String {
        switch self {
        case .urlInputError:
            return "URL is missing"
        }
    }
    case urlInputError
}

enum ResponseError: NetworkError {
    func errorDescription() -> String {
        switch self {
        case .noDataFound:
            return "No Data Found"
        case .responseMapFailure:
            return "Json Response Mapping Failed"
        }
    }
    
    init(error: Error) {
        debugPrint(error)
        self = .noDataFound
    }
    
    init(statusCode: Int) {
        switch statusCode {
        case 404:
            self = .noDataFound
            break
        default:
            self = .noDataFound
            break
        }
    }
    
    case noDataFound
    case responseMapFailure
}
