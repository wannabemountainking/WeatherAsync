//
//  WeatherDetailView.swift
//  WeatherAsync
//
//  Created by YoonieMac on 3/22/26.
//

import SwiftUI

struct WeatherDetailView: View {
    @State private var vm: WeatherViewModel = .init()
    var weatherInfo: Weather?
    var cityName: String?
    var cityWeathers: [Weather] {
        vm.weathers.filter { $0.cityName != self.cityName }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 10) {
                Text(cityName ?? "장소가 목록에 없습니다")
                Text("\(weatherInfo?.currentTemp ?? "0.0") ℃")
                Text("최고  \(weatherInfo?.highestTemp ?? "0.0") ℃ / 최저  \(weatherInfo?.lowestTemp ?? "0.0") ℃")
            }
            .padding(.horizontal)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding(16)
    
            HStack {
                VStack(spacing: 10) {
                    Text("습도")
                    Text("\(weatherInfo?.currentHumidity ?? "0.0") %")
                }
                .frame(maxWidth: .infinity)
                VStack(spacing: 10) {
                    Text("풍속")
                    Text("\(weatherInfo?.windSpeed ?? "0.0") km/h")
                }
                .frame(maxWidth: .infinity)
                VStack(spacing: 10) {
                    Text("체감온도")
                    Text("\(weatherInfo?.currentHumidity ?? "0.0") ℃")
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 30)
            
            List {
                ForEach(self.cityWeathers, id: \.id) { weather in
                    HStack {
                        Text(weather.cityName)
                        Spacer()
                        Text(weather.currentTemp)
                    }
                }
            }
            
            Spacer()
        }
    }
}

#Preview {
    WeatherDetailView()
}
