//
//  MetaWeatherFeedTests.swift
//  MetaWeatherFeedTests
//
//  Created by mustafa salah eldin on 2/1/22.
//

import XCTest
@testable import MetaWeatherFeed


class NetworkManagerTests: XCTestCase {
    
    var sut: NetworkManager!
    override func setUp() {
        super.setUp()
        sut = NetworkManager(httpClient: URLSessionHTTPClient(session: URLSession.shared))
    }
    
    func test_getFromURL_shouldMapRetreivedValueToPassedCodableObject() {
        let exp = expectation(description: "Expect that weather object to be retrieved")
        let weatherRealURL = "location/839722"
        
        sut.get(url: weatherRealURL, httpMethod: .get, parameters: nil, success: { (retrivedCodable:ConsolidatedWeatherRoot) in
            exp.fulfill()
            XCTAssertNotNil(retrivedCodable.consolidatedWeather?[0].id)
            XCTAssertNotNil(retrivedCodable.consolidatedWeather?[0].weatherStateAbbr)
        },failure: { error in
            
        }
    )
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    
}

class NetworkManager {
    let baseUrl = "https://www.metaweather.com/api/"
     var httpClient:HTTPClient!
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient;
    }
    
    func get<T: Decodable>(url: String, httpMethod: NetworkHttpMethod, parameters: [String: Any]?, success:@escaping (T)-> (), failure:@escaping (Error)->()) {
        guard let requestURL = URL(string:  baseUrl+url ) else {return}
        self.httpClient.get(from: requestURL) { (resultValue:HTTPClient.Result) in
            
            switch resultValue {
            case .failure(let error):
                break
            case .success((let data, let response)):
                debugPrint("response is \(response)")
                let decodedValue: ConsolidatedWeatherRoot? = self.decode(responseData: data)
                if let decodedValue = decodedValue as? T {
                    success(decodedValue)
                }else {

                }
                break
            }
        }
    }
    
    func decode<T: Decodable>(responseData: Data) -> T? {
        do {
            let responseModel = try JSONDecoder().decode(T.self, from: responseData)
            return responseModel
        } catch {
            return nil
            
        }
        
    }
    
    
    enum NetworkHttpMethod: String {
        case get = "GET"
        case post = "POST"
    }

}


// MARK: - ConsolidatedWeatherRoot
struct ConsolidatedWeatherRoot: Codable {
    let consolidatedWeather: [ConsolidatedWeather]?
    
    enum CodingKeys: String, CodingKey {
        case consolidatedWeather = "consolidated_weather"
    }
}

// MARK: - ConsolidatedWeather
struct ConsolidatedWeather: Codable {
    let id: Int?
    let weatherStateName, weatherStateAbbr, windDirectionCompass, created: String?
    let applicableDate: String?
    let minTemp, maxTemp, theTemp, windSpeed: Double?
    let windDirection, airPressure: Double?
    let humidity: Int?
    let visibility: Double?
    let predictability: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case weatherStateName = "weather_state_name"
        case weatherStateAbbr = "weather_state_abbr"
        case windDirectionCompass = "wind_direction_compass"
        case created
        case applicableDate = "applicable_date"
        case minTemp = "min_temp"
        case maxTemp = "max_temp"
        case theTemp = "the_temp"
        case windSpeed = "wind_speed"
        case windDirection = "wind_direction"
        case airPressure = "air_pressure"
        case humidity, visibility, predictability
    }
}

