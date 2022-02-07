//
//  NetworkManagerTests.swift
//  MetaWeatherFeedTests
//
//  Created by mustafa salah eldin on 2/7/22.
//

import XCTest
@testable import MetaWeatherFeed

class NetworkManagerTests: XCTestCase {
    var anyStringUrl = "www.any-url.com"
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func test_getFromUrl_shouldFailInCaseStatusCodeIsGreaterThan299(){
        let (sut, urlSession) = makeSUT()
        let data = Data()
        let failedStatusCodes = [300, 301, 400, 401, 402, 403, 404, 500]
        failedStatusCodes.forEach { number in
            let response = HTTPURLResponse(url: anyURL(), statusCode: number, httpVersion: nil, headerFields: nil)!
            urlSession.completions.append( (HTTPClient.Result {return (data, response)}))
        }
        sut.get(url: anyStringUrl, httpMethod: .get, parameters: nil) { (a:DecodableTest) in
            XCTFail()
        } failure: { error in
           XCTAssertNotNil(error)
        }
    }
    
    func makeSUT() -> (NetworkManager, URLSessionSpy) {
        let urlSession = URLSessionSpy()
        let networkManager = NetworkManager(httpClient: urlSession)
        return (networkManager, urlSession)
    }
    
}

private class DecodableTest: Decodable {
    
}

class URLSessionSpy: HTTPClient {
    var completions = [(HTTPClient.Result)]()
    func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        for i in 0..<completions.count {
            completion(completions[i])
        }
        return Task()
    }
}

private class Task: HTTPClientTask {
    func cancel() {
        
    }
    
}

