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
        expectTo(sut: sut, successExpected: true)

    }
    
    func test_getFromUrl_shouldFailInCaseStatusCodeIsLessThan300AndJSONResponseIsWrong() {
        let (sut, urlSession) = makeSUT()
        let data = Data()
        let failedStatusCodes = [200, 201, 202, 210, 220, 240, 250, 299]
        failedStatusCodes.forEach { number in
            let response = HTTPURLResponse(url: anyURL(), statusCode: number, httpVersion: nil, headerFields: nil)!
            urlSession.completions.append( (HTTPClient.Result {return (data, response)}))
        }
    }
    
    //MARK: Helpers
    
    func makeSUT() -> (NetworkManager, URLSessionSpy) {
        let urlSession = URLSessionSpy()
        let networkManager = NetworkManager(httpClient: urlSession)
        return (networkManager, urlSession)
    }
    
    func expectTo(sut:NetworkManager, successExpected: Bool) {
        sut.get(url: anyStringUrl, httpMethod: .get, parameters: nil) { (a:DecodableTest) in
            XCTAssert(successExpected)
        } failure: { error in
            XCTAssert(!successExpected)
        }
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

