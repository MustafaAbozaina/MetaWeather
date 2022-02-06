//
//  TestHelpers.swift
//  MetaWeatherFeedTests
//
//  Created by mustafa salah eldin on 2/3/22.
//

import XCTest

func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0)
}

func anyURL() -> URL {
    return URL(string: "http://any-url.com")!
}

func anyData() -> Data {
    return Data("any data".utf8)
}
