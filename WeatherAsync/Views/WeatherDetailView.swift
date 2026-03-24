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
        VStack(alignment: .leading, spacing: 10) {
            
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(hex: "1C6DD0") ?? Color.gray.opacity(0.5))
                    .frame(maxWidth: .infinity)
                    .frame(height: 180)
                    .padding(16)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(cityName ?? "장소가 목록에 없습니다")
                        .font(.title2.bold())
                    Text("\(weatherInfo?.currentTemp ?? "0.0") ℃")
                        .font(Font.system(size: 52, weight: .thin))
                    Text("최고  \(weatherInfo?.highestTemp ?? "0.0") ℃ / 최저  \(weatherInfo?.lowestTemp ?? "0.0") ℃")
                }
                .foregroundStyle(.white)
                .padding(.horizontal)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(16)
            }
    
            HStack(spacing: 20) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(uiColor: UIColor.secondarySystemBackground))
                    VStack(spacing: 10) {
                        Text("습도")
                        Text("\(weatherInfo?.currentHumidity ?? "0.0") %")
                    }
                    .frame(maxWidth: .infinity)
                }
                .frame(height: 80)
                .frame(maxWidth: .infinity)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(uiColor: UIColor.secondarySystemBackground))
                    VStack(spacing: 10) {
                        Text("풍속")
                        Text("\(weatherInfo?.windSpeed ?? "0.0") km/h")
                    }
                    .frame(maxWidth: .infinity)
                }
                .frame(height: 80)
                .frame(maxWidth: .infinity)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(uiColor: UIColor.secondarySystemBackground))
                    VStack(spacing: 10) {
                        Text("체감온도")
                        Text("\(weatherInfo?.apparentTemp ?? "0.0") ℃")
                    }
                    .frame(maxWidth: .infinity)
                }
                .frame(height: 80)
                .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 20)
                
            Spacer()
        }
    }
}

extension Color {
    init?(hex: String) {
        var rgb: [CGFloat] = []
        
        stride(from: 0, to: hex.count as Int, by: 2).forEach { index in
            let start = hex.index(hex.startIndex, offsetBy: index)
            let end = hex.index(start, offsetBy: 2)
            let colorString = String(hex[start..<end])
            guard let colorInt = Int(colorString, radix: 16) else { return }
            let colorCGFloat = CGFloat(colorInt) / 255
            rgb.append(colorCGFloat)
        }
        if rgb.count != 3 {
            return nil
        }
        self = Color(uiColor: UIColor(red: rgb[0], green: rgb[1], blue: rgb[2], alpha: 1.0))
    }
}

#Preview {
    WeatherDetailView()
}
