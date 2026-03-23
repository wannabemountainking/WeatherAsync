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
            
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .background(Color(uiColor: UIColor(red: 28.0, green: 109.0, blue: 208.0, alpha: 1.0)))
                    .padding(16)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(cityName ?? "장소가 목록에 없습니다")
                    Text("\(weatherInfo?.currentTemp ?? "0.0") ℃")
                    Text("최고  \(weatherInfo?.highestTemp ?? "0.0") ℃ / 최저  \(weatherInfo?.lowestTemp ?? "0.0") ℃")
                }
                .foregroundStyle(.white)
                .padding(.horizontal)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(16)
            }
            
            
            
    
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

extension Color {
    init(hex: String) {
        var hexArr: [String] = []
        
    }
}

#Preview {
    WeatherDetailView()
}
