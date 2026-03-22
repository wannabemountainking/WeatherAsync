//
//  Weather.swift
//  WeatherAsync
//
//  Created by YoonieMac on 3/22/26.
//

import Foundation

/*
 현재 온도 / 최고·최저 / 습도 / 풍속 / 체감온도 표시
 */


// MARK: - Weather
struct Weather: Identifiable, Codable {
    let id = UUID()
    var cityName: String = "서울"
    var latitude, longitude: Double
    let current: Current
    let hourly: Hourly
    
    enum CodingKeys: String, CodingKey {
        case latitude, longitude
        case current
        case hourly
    }
    
    var currentTemp: String { current.temperature2M.formatted(.number.precision(.fractionLength(1))) }
    var hourlyTemporatureOfToday: [Double] { Array(hourly.temperature2M[0...23]) }
    var highestTemp: String {
        guard let highestTemperatures = hourlyTemporatureOfToday.max() else {return "0.0"}
        return highestTemperatures.formatted(.number.precision(.fractionLength(1)))
    }
    var lowestTemp: String {
        guard let lowestTemporatures = hourlyTemporatureOfToday.min() else {return "0.0"}
        return lowestTemporatures.formatted(.number.precision(.fractionLength(1)))
    }
    var currentHumidity: String { current.relativeHumidity2M.formatted(.number.precision(.fractionLength(1))) }
    var windSpeed: String { current.windSpeed10M.formatted(.number.precision(.fractionLength(1))) }
    var apparentTemp: String { current.apparentTemperature.formatted(.number.precision(.fractionLength(1))) }
    
}

// MARK: - Current
struct Current: Codable {
    let temperature2M, apparentTemperature, relativeHumidity2M, windSpeed10M: Double

    enum CodingKeys: String, CodingKey {
        case temperature2M = "temperature_2m"
        case apparentTemperature = "apparent_temperature"
        case relativeHumidity2M = "relative_humidity_2m"
        case windSpeed10M = "wind_speed_10m"
    }
}

// MARK: - Hourly
struct Hourly: Codable {
    let temperature2M: [Double]

    enum CodingKeys: String, CodingKey {
        case temperature2M = "temperature_2m"
    }
}
