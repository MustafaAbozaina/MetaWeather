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
        guard let jsonData = try?  JSONSerialization.data(
            withJSONObject: weatherJsonTestData,
            options: .prettyPrinted
        ) else {
            XCTFail()
            return
        }
        let weatherRoot: ConsolidatedWeatherRoot? = sut.decode(responseData: jsonData)
        XCTAssertNotNil(weatherRoot?.consolidatedWeather)
        XCTAssertEqual(weatherRoot?.consolidatedWeather?[0].id, 6306969095766016)
        XCTAssertEqual(weatherRoot?.consolidatedWeather?[0].minTemp, -1.06)
    }
    
    func test_getFromUrl_shouldFailInCaseIfError() {
        let (sut, urlSession) = makeSUT()
        urlSession.completions.append(HTTPClient.Result {throw MockedError()})
        expect(sut: sut, to: .fail)
    }
    
    //MARK: Helpers
    
    func makeSUT() -> (NetworkManager, URLSessionSpy) {
        let urlSession = URLSessionSpy()
        let networkManager = NetworkManager(httpClient: urlSession)
        return (networkManager, urlSession)
    }
    
    func expect(sut:NetworkManager, to expectation: TestExpectation) {
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


// MARK: testing data

private var weatherJsonTestData: [String: Any] =
["consolidated_weather": [
    [
        "id": 6306969095766016,
        "weather_state_name": "Heavy Cloud",
        "weather_state_abbr": "hc",
        "wind_direction_compass": "W",
        "created": "2022-01-31T14:00:55.247050Z",
        "applicable_date": "2022-01-31",
        "min_temp": -1.06,
        "max_temp": 4.7,
        "the_temp": 2.685,
        "wind_speed": 6.69000353256449,
        "wind_direction": 272.3332279826744,
        "air_pressure": 1014.5,
        "humidity": 60,
        "visibility": 14.435384852461624,
        "predictability": 71
    ]]]
