//
//  MetaWeatherFeedTests.swift
//  MetaWeatherFeedTests
//
//  Created by mustafa salah eldin on 2/1/22.
//

import XCTest
@testable import MetaWeatherFeed


class NetworkManagerEndToEndTests: XCTestCase {
    private var validUrl = "location/839722"
    private var invalidUrl = "location/83"
    var sut: NetworkManager!
    override func setUp() {
        super.setUp()
        sut = NetworkManager(httpClient: URLSessionHTTPClient(session: URLSession.shared))
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_getFromURL_shouldMapRetreivedValueToPassedCodableObject() {
        let exp = expectation(description: "Expect that weather object to be retrieved")
        
        sut.get(url: validUrl, httpMethod: .get, parameters: nil, success: { (retrivedCodable:ConsolidatedWeatherRoot) in
            exp.fulfill()
            XCTAssertNotNil(retrivedCodable.consolidatedWeather?[0].id)
            XCTAssertNotNil(retrivedCodable.consolidatedWeather?[0].weatherStateAbbr)
        },failure: { error in
            XCTFail()
        }
        )
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func test_getFromUrl_shouldFailIfUrlIsWrong() {
        let exp = expectation(description: "Expect to fail because of wrong url")
        
        sut.get(url: invalidUrl, httpMethod: .get, parameters: nil, success: { (retrivedCodable:ConsolidatedWeatherRoot) in
            XCTFail()
        },failure: { error in
            exp.fulfill()
            XCTAssertNotNil(error)
        }
        )
        waitForExpectations(timeout: 5, handler: nil)
    }
    
}
