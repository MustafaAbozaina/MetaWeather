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
    let successStatusCodes = [200, 201, 202, 210, 220, 240, 250, 299]
    
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
        expect(sut: sut, to: .fail)

    }
    
    func test_getFromUrl_shouldFailInCaseStatusSuccessStatusCodesAndJSONResponseIsWrong() {
        let (sut, urlSession) = makeSUT()
        let data = Data()
        successStatusCodes.forEach { number in
            let response = HTTPURLResponse(url: anyURL(), statusCode: number, httpVersion: nil, headerFields: nil)!
            urlSession.completions.append( (HTTPClient.Result {return (data, response)}))
        }
        expect(sut: sut, to: .fail)
    }
    
    func test_getFromUrl_shouldSuccessInCaseSuccessStatusCodesWithCorrectJSONResponse() {
        let (sut, urlSession) = makeSUT()
        let data = encodeJSON(value: validJSONValue)
        successStatusCodes.forEach { number in
            let response = HTTPURLResponse(url: anyURL(), statusCode: number, httpVersion: nil, headerFields: nil)!
            urlSession.completions.append( (HTTPClient.Result {return (data, response)}))
        }
        expect(sut: sut, to: .success)
    }
    
    func test_decodeJson_shouldDecodeDataSuccessfully(){
        let (sut, _) = makeSUT()
        let bundle = Bundle(for: type(of: self))

        
        guard let filepath = bundle.path(forResource: "WeatherRoot", ofType: "json"),
              let data = filepath.getDataContentsFromPath() else {
                return
        }

        let weatherRoot: ConsolidatedWeatherRoot? = sut.decode(responseData: data)
        XCTAssertNotNil(weatherRoot?.consolidatedWeather)
        XCTAssertEqual(weatherRoot?.consolidatedWeather?[0].id, 4928525111918592)
        XCTAssertEqual(weatherRoot?.consolidatedWeather?[0].minTemp,-8.295)
    }
    
    func test_getFromUrl_shouldFailInCaseIfError() {
        let (sut, urlSession) = makeSUT()
        urlSession.completions.append(HTTPClient.Result {throw MockedError()})
        expect(sut: sut, to: .fail)
    }
    
    //MARK: Helpers
    
    func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (NetworkManager, URLSessionSpy) {
        let urlSession = URLSessionSpy()
        let sut = NetworkManager(httpClient: urlSession)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, urlSession)
    }
    
    func expect(sut:NetworkManager, to expectation: TestExpectation, file: StaticString = #filePath, line: UInt = #line) {
        sut.get(url: anyStringUrl, httpMethod: .get, parameters: nil) { (decodable:DecodableTest) in
            XCTAssert(expectation == .success)
        } failure: { error in
            XCTAssert(expectation == .fail)
        }
    }
    
    enum TestExpectation {
        case success
        case fail
    }
    
}

private class DecodableTest: Decodable {
    var id: Int?
    var name: String?
}

private class MockedError: Error {
    
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

private var validJSONValue: [String : Any] = ["id":1, "namse": "name"]

private func encodeJSON(value: [String:Any]) ->Data {
    
    guard let jsonData = try?  JSONSerialization.data(
        withJSONObject: value,
        options: .prettyPrinted
    ) else {
        return Data()
    }
    return jsonData
}



extension Dictionary {
    func toData() -> Data?{
        guard let jsonData = try? JSONSerialization.data(
            withJSONObject: self,
            options: .prettyPrinted
        ) else {
            return nil
        }
        return jsonData
    }
}

extension String {
    func getDataContentsFromPath() -> Data? {
            guard  let data = try? Data(contentsOf: URL(fileURLWithPath: self)) else {
                return nil
            }
        return data
    }
    
    func getContentFromPath() -> Any?{
        guard let contents = try? String(contentsOf: URL(fileURLWithPath: self)) else {
            return nil
        }
        return contents
    }
}


