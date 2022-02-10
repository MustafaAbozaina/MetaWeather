//
//  WeatherDataManager.swift
//  MetaWeatherFeed
//
//  Created by mustafa salah eldin on 2/10/22.
//

import Foundation


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
