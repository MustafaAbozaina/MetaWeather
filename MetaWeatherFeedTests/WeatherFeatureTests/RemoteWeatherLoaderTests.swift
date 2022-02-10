//
//  MetaWeatherFeedEndToEndTests.swift
//  MetaWeatherFeedEndToEndTests
//
//  Created by mustafa salah eldin on 2/4/22.
//

import XCTest
@testable import MetaWeatherFeed


class RemoteWeatherLoaderTests: XCTestCase {
    let locationId = 839722
    let baseURL = "https://www.metaweather.com/api/"
    var sut: RemoteWeatherLoader!
   
    override func setUp() {
        super.setUp()
    }
    
    func test_loadWeatherOnce_shouldCalledGetFromURLOnce() {
        let (sut, networkManager) = makeSUT()

        sut.getWeatherInfo(locationId: locationId, success:{ (weatherRoot:ConsolidatedWeatherRoot) in
            
        },failure: { _ in
        
        })
        
        XCTAssertEqual(networkManager.getMethodCallingNumbers, 1)
    }
    
    func test_loadWeatherTwice_shouldCalledGetFromURLTwice() {
        let (sut, networkManager) = makeSUT()

        sut.getWeatherInfo(locationId: locationId, success:{ (weatherRoot:ConsolidatedWeatherRoot) in
            
        },failure: { _ in
        
        })
        sut.getWeatherInfo(locationId: locationId, success:{ (weatherRoot:ConsolidatedWeatherRoot) in
            
        },failure: { _ in
        
        })
        
        XCTAssertEqual(networkManager.getMethodCallingNumbers, 2)
    }
  
    func test_loadWeatherUsingURL_shouldUseThatURL() {
        let (sut, networkManager) = makeSUT()

        sut.getWeatherInfo(locationId: locationId, success:{ (weatherRoot:ConsolidatedWeatherRoot) in
            
        },failure: { _ in
        
        })
        XCTAssertEqual(networkManager.sentURL, "location/\(locationId)")
        XCTAssertEqual(networkManager.baseUrl+networkManager.sentURL, baseURL+"location/\(locationId)")
    }
    
    func test_loadWeatherWithValidLocation_shouldFireSuccess() {
        let (sut, _) = makeSUT()

        sut.getWeatherInfo(locationId: locationId, success:{ (weatherRoot:ConsolidatedWeatherRoot) in
            XCTAssertNotNil(weatherRoot)
        },failure: { _ in
            XCTFail()
        })
    }
    
    func test_getWeatherFailed_shouldFireFailureClosure() {
        let (sut, networkManager) = makeSUT()
        networkManager.failuresCompletions.append(NetworkManagerSpy<Any>.ResponseError.noDataFound)
        sut.getWeatherInfo(locationId: locationId, success:{ (weatherRoot:ConsolidatedWeatherRoot) in
            XCTFail()
        },failure: { error in
            XCTAssertNotNil(error)
        })
    }
    
    func test_getWeatherSuccess_shouldFireSucccessClosure() {
        let (sut, networkManager) = makeSUT()
        networkManager.successCompletions.append(ConsolidatedWeatherRoot(consolidatedWeather: nil))
        sut.getWeatherInfo(locationId: locationId, success:{ (weatherRoot:ConsolidatedWeatherRoot) in
            XCTAssertNotNil(weatherRoot)
        },failure: { error in
            XCTFail()
        })
    }
    
    // MARK: Helpers
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (RemoteWeatherLoader, NetworkManagerSpy<ConsolidatedWeatherRoot>) {
        let networkManager = NetworkManagerSpy<ConsolidatedWeatherRoot>()
        let sut = RemoteWeatherLoader(networkManager: networkManager)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, networkManager)
    }
    
}

protocol WeatherLoader {
    func getWeatherInfo(locationId: Int, success:@escaping (ConsolidatedWeatherRoot)->(), failure: @escaping (Error)->())
}

class RemoteWeatherLoader: WeatherLoader {
    var networkManager: NetworkManager!
    init(networkManager:NetworkManager) {
        self.networkManager = networkManager
    }
    
    func getWeatherInfo(locationId: Int, success:@escaping (ConsolidatedWeatherRoot)->(), failure:@escaping (Error)->()) {
        let url = "location/\(locationId)"
        self.networkManager.get(url: url, httpMethod: .get, parameters: nil, success: { (weatherRoot: ConsolidatedWeatherRoot) in
            success(weatherRoot)
        }, failure: { networkError in
            failure(networkError)
        })
    }
}

private class NetworkManagerSpy<T>: NetworkManager {
    var getMethodCallingNumbers = 0
    var sentURL = ""
    var successCompletions = [T]()
    var failuresCompletions = [NetworkError]()

    override func get<T>(url: String, httpMethod: NetworkManager.NetworkHttpMethod, parameters: [String : Any]?, success: @escaping (T) -> Void, failure: @escaping (NetworkError) -> ()) where T : Decodable {
        getMethodCallingNumbers += 1
        sentURL = url
        for i in 0..<successCompletions.count {
            success(successCompletions[i] as! T)
        }
        for i in 0..<failuresCompletions.count {
            failure(failuresCompletions[i])
        }
    }
    
    override func defaultInitialization() {
        self.httpClient = URLSessionHTTPClient(session: URLSession.shared)
    }
}
