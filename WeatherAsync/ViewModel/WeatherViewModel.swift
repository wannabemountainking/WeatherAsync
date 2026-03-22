//
//  WeatherViewModel.swift
//  WeatherAsync
//
//  Created by YoonieMac on 3/22/26.
//

import Foundation


enum NetworkError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case invalidData
    case invalidCityName
    
    var errorDescription: String? {
        switch self {
        case .invalidCityName: return "도시명이 잘못되었습니다"
        case .invalidURL: return "URL 오류 발생"
        case .invalidData: return "데이터 디코딩 에러 발생"
        case .invalidResponse: return "서버 응답 에러 발생"
        }
    }
}

@Observable
final class WeatherViewModel {

    var weatherData: Weather?
    var isLoading: Bool = false
    var errorMessage: String = ""
    var cityName: String = "서울"
    
    var cities: [String: (lat: Double, lon: Double)] = [
        "서울": (37.5665, 126.9780),
        "부산": (35.1796, 129.0756),
        "제주": (33.4996, 126.5312),
        "도쿄": (35.6762, 139.6503),
        "뉴욕": (40.7128, -74.0060)
    ]
    

    func fetchWeatherData(cityName: String) async {
        self.isLoading = true
        do {
            guard let cityLocation = self.cities[cityName] else {
                throw NetworkError.invalidCityName
            }
            let endPoint = "https://api.open-meteo.com/v1/forecast?latitude=\(cityLocation.lat)&longitude=\(cityLocation.lon)&current=temperature_2m,apparent_temperature,relative_humidity_2m,wind_speed_10m&timezone=auto"
            guard let url = URL(string: endPoint) else {
                throw NetworkError.invalidURL
            }
            try await self.downloadWeatherInfo(url: url)
        } catch {
            self.errorMessage = error.localizedDescription
        }
        self.isLoading = false
    }
    
    private func downloadWeatherInfo(url: URL) async throws {
        let (weather, response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
            throw NetworkError.invalidResponse
        }
        guard let weatherInfo = try? JSONDecoder().decode(Weather.self, from: weather) else {
            throw NetworkError.invalidData
        }
        self.weatherData = weatherInfo
    }
}
