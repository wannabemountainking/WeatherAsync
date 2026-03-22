//
//  WeatherDetailView.swift
//  WeatherAsync
//
//  Created by YoonieMac on 3/22/26.
//

import SwiftUI

struct WeatherDetailView: View {
    var weatherInfo: Weather?
    var cityName: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Form {
                VStack(alignment: .leading, spacing: 10) {
                    Text(cityName ?? "장소가 목록에 없습니다")
                    Text("\(weatherInfo?.currentTemp ?? "0.0") ℃")
                    Text("최고  \(weatherInfo?.highestTemp ?? "0.0") ℃ / 최저  \(weatherInfo?.lowestTemp ?? "0.0") ℃")
                }
            }
        
            HStack(spacing: 80) {
                VStack(spacing: 10) {
                    Text("습도")
                    Text("\(weatherInfo?.currentHumidity ?? "0.0") %")
                }
                VStack(spacing: 10) {
                    Text("풍속")
                    Text("\(weatherInfo?.windSpeed ?? "0.0") km/h")
                }
                VStack(spacing: 10) {
                    Text("체감온도")
                    Text("\(weatherInfo?.currentHumidity ?? "0.0") ℃")
                }
            }
            .padding(.horizontal, 30)
            Spacer()
        }
    }
}

#Preview {
    WeatherDetailView()
}
