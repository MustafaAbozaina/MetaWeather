//
//  WeatherLoader+Protocol.swift
//  MetaWeatherFeed
//
//  Created by mustafa salah eldin on 2/10/22.
//

import Foundation

protocol WeatherLoader {
    func getWeatherInfo(locationId: Int, success:@escaping (ConsolidatedWeatherRoot)->(), failure: @escaping (Error)->())
}
