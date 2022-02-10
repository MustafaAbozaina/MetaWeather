//
//  WeatherDataManager.swift
//  MetaWeatherFeedTests
//
//  Created by mustafa salah eldin on 2/8/22.
//

import XCTest
@testable import MetaWeatherFeed


class WeatherDataManager {
    var remoteLoader: WeatherLoader?
    var localeLoader: WeatherLoader?
    init(remoteLoader: WeatherLoader, localeLoader: WeatherLoader) {
        self.remoteLoader = remoteLoader
        self.localeLoader = localeLoader
    }
    
    func loadWeatherInfo(locationId: Int){
        getFromRemote(locationId: locationId, faliure: { [weak self] in
            self?.getFromLocale(locationId: locationId)
        })
    }
    
    func getFromRemote(locationId: Int, faliure: @escaping ()-> ()) {
        
        self.remoteLoader?.getWeatherInfo(locationId: locationId, success: { (weatherRoot:ConsolidatedWeatherRoot) in
            
        }, failure: { error in
            
        })
    }
    
    func getFromLocale(locationId: Int) {
        self.localeLoader?.getWeatherInfo(locationId: locationId, success: { (weatherRoot:ConsolidatedWeatherRoot) in
            
        }, failure: { error in
            
        })
    }
    
}

class WeatherDataManagerTests: XCTestCase {

    func test_getWeatherData_shouldRetrieveListOfWeatherDaysWithItsWeatherInfo() {
        let remoteWeatherLoader = RemoteWeatherLoaderSpy()
        let localWeatherLoader = LocaleWeatherLoaderSpy()
        let sut = WeatherDataManager(remoteLoader: remoteWeatherLoader, localeLoader:localWeatherLoader )
        
    }
}

class RemoteWeatherLoaderSpy: WeatherLoader {
    func getWeatherInfo(locationId: Int, success: @escaping (ConsolidatedWeatherRoot) -> (), failure: @escaping (Error) -> ()) {
        
    }
    
    
}

class LocaleWeatherLoaderSpy: WeatherLoader {
    func getWeatherInfo(locationId: Int, success: @escaping (ConsolidatedWeatherRoot) -> (), failure: @escaping (Error) -> ()) {
        
    }
    
    
}
