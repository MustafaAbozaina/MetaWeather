//
//  MetaWeatherFeedEndToEndTests.swift
//  MetaWeatherFeedEndToEndTests
//
//  Created by mustafa salah eldin on 2/4/22.
//

import XCTest
@testable import MetaWeatherFeed

let validLocationId = 839722

class RemoteWeatherLoaderTests: XCTestCase {
    var validUrl = ""
    
    var sut: RemoteWeatherLoader!
   
    override func setUp() {
        super.setUp()
        
    }
    
    func test_loadWeatherOnce_shouldCalledGetFromURLOnce() {
        let networkManager = NetworkManagerSpy()
        sut = RemoteWeatherLoader(networkManager: networkManager)

        sut.getWeatherInfo(locationId: validLocationId)
        
        XCTAssertEqual(networkManager.getMethodCallingNumbers, 1)
    }
    
    func test_loadWeatherTwice_shouldCalledGetFromURLTwice() {
        let networkManager = NetworkManagerSpy()
        sut = RemoteWeatherLoader(networkManager: networkManager)

        sut.getWeatherInfo(locationId: validLocationId)
        sut.getWeatherInfo(locationId: validLocationId)
        
        XCTAssertEqual(networkManager.getMethodCallingNumbers, 2)
    }
  
    func test_loadWeatherUsingURL_shouldUseThatURL() {
        let networkManager = NetworkManagerSpy()
        sut = RemoteWeatherLoader(networkManager: networkManager)

        sut.getWeatherInfo(locationId: validLocationId)
        
        XCTAssertEqual(networkManager.sentURL, "location/\(validLocationId)")
    }
    
}

protocol WeatherLoader {
    func getWeatherInfo(locationId: Int)

}

class RemoteWeatherLoader: WeatherLoader {
    var networkManager: NetworkManager!
    init(networkManager:NetworkManager) {
        self.networkManager = networkManager
    }
    
    func getWeatherInfo(locationId: Int) {
        let url = "location/\(locationId)"
        self.networkManager.get(url: url, httpMethod: .get, parameters: nil) { (weatherRoot: ConsolidatedWeatherRoot) in
            
        } failure: { networkError in
            
        }

    }
}

class NetworkManagerSpy: NetworkManager {
    var getMethodCallingNumbers = 0
    var sentURL = ""
    override func get<T>(url: String, httpMethod: NetworkManager.NetworkHttpMethod, parameters: [String : Any]?, success: @escaping (T) -> (), failure: @escaping (NetworkError) -> ()) where T : Decodable {
        getMethodCallingNumbers += 1
        sentURL = url

    }
}

