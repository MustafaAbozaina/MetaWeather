//
//  WeatherDataManager.swift
//  MetaWeatherFeedTests
//
//  Created by mustafa salah eldin on 2/8/22.
//

import XCTest
@testable import MetaWeatherFeed

protocol WeatherDataManagerOutput: AnyObject {
    func succeededToGetWeather(weather:ConsolidatedWeatherRoot)
    func failedToGetWeather(error:Error)
}

class WeatherDataManager {
    var delegate: WeatherDataManagerOutput?
    var remoteLoader: WeatherLoader?
    var localeLoader: WeatherLoader?
    init(remoteLoader: WeatherLoader?, localeLoader: WeatherLoader?) {
        self.remoteLoader = remoteLoader
        self.localeLoader = localeLoader
        
    }
    func setDelegation(delegate: WeatherDataManagerOutput?) {
        self.delegate = delegate
    }
    
    func loadWeatherInfo(locationId: Int){
        getFromRemote(locationId: locationId, success: {[weak self] weatherRoot in
            self?.delegate?.succeededToGetWeather(weather: weatherRoot)
        }, faliure: { [weak self] in
            self?.getFromLocale(locationId: locationId)
        })
    }
    
    func getFromRemote(locationId: Int, success: @escaping (ConsolidatedWeatherRoot) -> (),faliure: @escaping ()-> ()) {
        
        self.remoteLoader?.getWeatherInfo(locationId: locationId, success: {  (weatherRoot:ConsolidatedWeatherRoot) in
            self.delegate?.succeededToGetWeather(weather: weatherRoot)
        }, failure: { [weak self] error in
            self?.getFromLocale(locationId: locationId)
        })
    }
    
    func getFromLocale(locationId: Int) {
        self.localeLoader?.getWeatherInfo(locationId: locationId, success: { [weak self] (weatherRoot:ConsolidatedWeatherRoot) in
            self?.delegate?.succeededToGetWeather(weather: weatherRoot)
        }, failure: {[weak self] error in
            self?.delegate?.failedToGetWeather(error: error)
        })
    }
    
}

class WeatherDataManagerTests: XCTestCase {

    func test_getWeatherData_shouldRetrieveListOfWeatherDaysWithItsWeatherInfo() {
       var (sut, remoteWeatherLoader) = makeSUT()
        remoteWeatherLoader.successResults.append(ConsolidatedWeatherRoot(consolidatedWeather: nil))
        sut.loadWeatherInfo(locationId: 839722)
    }
    
    func test_getWeatherData_shouldRetrieveError() {
        var (sut, remoteWeatherLoader) = makeSUT()
        remoteWeatherLoader.failureResults.append(ResponseError.noDataFound)
        sut.loadWeatherInfo(locationId: 2903)
    }
    
    
    func makeSUT(loaderType: WeatherLoaderType = .remote) -> (sut:WeatherDataManager, weatherLoader: WeatherLoaderSpy) {
        let remoteWeatherLoader = RemoteWeatherLoaderSpy()
        let localWeatherLoader = LocaleWeatherLoaderSpy()
        let sut = WeatherDataManager(remoteLoader: remoteWeatherLoader, localeLoader:localWeatherLoader)
        sut.setDelegation(delegate: WeatherViewModelShouldSucceedSpy(dataManager: sut as? WeatherDataManagerOutput))
        return loaderType == .remote ?  (sut,remoteWeatherLoader) : (sut,localWeatherLoader)
    }
    
    enum WeatherLoaderType {
        case remote
        case local
    }
    
}

protocol WeatherLoaderSpy {
    var successResults: [ConsolidatedWeatherRoot] { get set }
    var failureResults: [NetworkError] { get set }
}

class RemoteWeatherLoaderSpy: WeatherLoader, WeatherLoaderSpy {
    var successResults =  [ConsolidatedWeatherRoot]()
    
    var failureResults =  [NetworkError]()
    
    
    func getWeatherInfo(locationId: Int, success: @escaping (ConsolidatedWeatherRoot) -> (), failure: @escaping (Error) -> ()) {
        successResults.forEach { weatherRoot in
            success(weatherRoot)
        }
        failureResults.forEach { error in
            failure(error)
        }
    }
    
    
}

class LocaleWeatherLoaderSpy: WeatherLoader, WeatherLoaderSpy {
    var successResults =  [ConsolidatedWeatherRoot]()
    
    var failureResults =  [NetworkError]()
    
    func getWeatherInfo(locationId: Int, success: @escaping (ConsolidatedWeatherRoot) -> (), failure: @escaping (Error) -> ()) {
        
    }
    
}

class WeatherViewModelShouldSucceedSpy: WeatherViewModel, WeatherDataManagerOutput {
     override init(dataManager: WeatherDataManagerOutput?) {
         super.init(dataManager: dataManager)
    }
    func succeededToGetWeather(weather: ConsolidatedWeatherRoot) {
        XCTAssertNotNil(weather)
    }
    
    func failedToGetWeather(error: Error) {
        
    }
    
}

class WeatherViewModelShouldFailedSpy: WeatherViewModel, WeatherDataManagerOutput {
     override init(dataManager: WeatherDataManagerOutput?) {
         super.init(dataManager: dataManager)
    }
    func succeededToGetWeather(weather: ConsolidatedWeatherRoot) {
        
    }
    
    func failedToGetWeather(error: Error) {
        XCTAssertNotNil(error)
    }
    
}


// Production
class WeatherViewModel {
    var dataManager: WeatherDataManagerOutput?
    init(dataManager: WeatherDataManagerOutput?) {
        self.dataManager = dataManager
    }
    
    init(){
        
    }
    
}
