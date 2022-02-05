//
//  ConsolidatedWeatherRoot.swift
//  MetaWeatherFeed
//
//  Created by mustafa salah eldin on 2/5/22.
//

import Foundation

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
