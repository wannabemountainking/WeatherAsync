//
//  WeatherViewModel.swift
//  WeatherAsync
//
//  Created by YoonieMac on 3/22/26.
//

import Foundation
import CoreLocation
import MapKit


enum NetworkError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case invalidData
    case invalidCityName
    case invalidGeometricInformation
    
    var errorDescription: String? {
        switch self {
        case .invalidCityName: return "도시명이 잘못되었습니다"
        case .invalidURL: return "URL 오류 발생"
        case .invalidData: return "데이터 디코딩 에러 발생"
        case .invalidResponse: return "서버 응답 에러 발생"
        case .invalidGeometricInformation: return "지역 위치 정보 오류"
        }
    }
}

@MainActor
@Observable
final class WeatherViewModel {

    var weathers: [Weather] = []
    var isLoading: Bool = true
    var isSearching: Bool = false
    var errorMessage: String = ""
    var currentWeatherData: Weather?
    
    var cityNames: [String] = ["서울", "부산", "제주", "도쿄", "뉴욕"]
    
    init() {
        Task {
            await self.loadAllWeather()
        }
    }
    
//    func loadAllWeathers() async {
//        async let seoul = fetchWeatherData(cityName: "서울")
//        async let busan = fetchWeatherData(cityName: "부산")
//        async let jeju = fetchWeatherData(cityName: "제주")
//        async let tokyo = fetchWeatherData(cityName: "도쿄")
//        async let newyork = fetchWeatherData(cityName: "뉴욕")
//        
//        let fiveCityWeathers = await [seoul, busan, jeju, tokyo, newyork]
//        self.weathers = fiveCityWeathers.compactMap { $0 }
//    }
    
    func loadAllWeather() async {
        isLoading = true
        await withTaskGroup(of: (index: Int, weather: Weather?).self) { group in
            for (index, cityName) in cityNames.enumerated() {
                group.addTask {
                    let cityWeather = await self.fetchWeatherData(cityName: cityName)
                    return (index, cityWeather)
                }
            }
            var weathersOfCities: [(index: Int, weather: Weather)] = []
            for await (index, weather) in group {
                if let weather {
                    weathersOfCities.append((index, weather))
                }
            }
            self.weathers = weathersOfCities.sorted { $0.index < $1.index }.map { $0.weather }
            self.currentWeatherData = self.weathers.first
            print(errorMessage)
        }
        isLoading = false
    }

    func fetchWeatherData(cityName: String) async -> Weather? {
        defer {
            self.isSearching = false
        }
        
        self.isSearching = true
        do {
            guard let request = MKGeocodingRequest(addressString: cityName),
                  let coordinates = try await request.mapItems.first?.location.coordinate else {
                throw NetworkError.invalidGeometricInformation
            }
            let endPoint = "https://api.open-meteo.com/v1/forecast?latitude=\(coordinates.latitude)&longitude=\(coordinates.longitude)&current=temperature_2m,apparent_temperature,relative_humidity_2m,wind_speed_10m&timezone=auto&hourly=temperature_2m"
            guard let url = URL(string: endPoint) else {
                throw NetworkError.invalidURL
            }
            return try await self.downloadWeatherInfo(cityName: cityName, lat: coordinates.latitude, lon: coordinates.longitude, url: url)
        } catch {
            self.errorMessage = error.localizedDescription
        }
        return nil
    }
    
    private func downloadWeatherInfo(cityName: String, lat: Double, lon: Double, url: URL) async throws -> Weather {
        let (weather, response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
            throw NetworkError.invalidResponse
        }
        if let jsonString = String(data: weather, encoding: .utf8) {
            print(jsonString)
        }
        guard var weatherInfo = try? JSONDecoder().decode(Weather.self, from: weather) else {
            throw NetworkError.invalidData
        }
        weatherInfo.cityName = cityName
        weatherInfo.latitude = lat
        weatherInfo.longitude = lon
        return weatherInfo
    }
}
