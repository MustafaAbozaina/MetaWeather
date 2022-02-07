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
    
    func test_decodeJson_shouldDecodeDataSuccessfully(){
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
    }
    
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
