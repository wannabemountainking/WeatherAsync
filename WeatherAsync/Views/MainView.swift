//
//  MainView.swift
//  WeatherAsync
//
//  Created by YoonieMac on 3/22/26.
//

import SwiftUI

struct MainView: View {
    @State private var vm: WeatherViewModel = .init()
    @State private var currentCity: String = "서울"
    @State private var cityName: String = "서울"
    var cityWeathers: [Weather] {
        vm.weathers.filter { $0.cityName != cityName }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                HStack(spacing: 10) {
                    Button("", systemImage: "magnifyingglass") {
                        Task {
                            vm.currentWeatherData = await vm.fetchWeatherData(cityName: currentCity)
                            cityName = currentCity
                        }
                    }
                    .font(.title)
                    TextField("도시 검색", text: $currentCity)
                        .textFieldStyle(.roundedBorder)
                        .font(.title2)
                        .autocorrectionDisabled()
                        .autocapitalization(.none)
                }
                .padding(.top, 20)
                .padding(10)
                
                if vm.isLoading {
                    ProgressView("불러오는 중 ...")
                        .font(.title)
                } else if let weatherInfo = vm.currentWeatherData {

                    WeatherDetailView(weatherInfo: weatherInfo, cityName: cityName)
                    
                    ForEach(cityWeathers, id: \.id) { weather in
                        NavigationLink {
                            WeatherDetailView(weatherInfo: weather, cityName: weather.cityName)
                        } label: {
                            HStack {
                                Text(weather.cityName)
                                    .font(.title2)
                                    .padding(.horizontal)
                                Spacer()
                                Text("\(weather.currentTemp) ℃")                            .font(.title2)
                                    .fontWeight(.light)
                                    .padding(.horizontal)
                            }
                        }
                        .frame(height: 30)
                        .frame(maxWidth: .infinity)
                        .padding(5)
                        .padding(.horizontal)
                        .buttonStyle(.borderedProminent)
                    }
                } else {
                    ContentUnavailableView("네트워크 오류", systemImage: "exclamationmark.triangle", description: Text("날씨를 불러 올 수 없어요").font(.title3))
                    Button(action: {
                        Task {
                            vm.currentWeatherData = await vm.fetchWeatherData(cityName: currentCity)
                        }
                    }, label: {
                        Text("다시 시도")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                    })
                    .buttonStyle(.borderedProminent)
                    .padding()
                }
                
                Spacer()
            } //:VSTACK
            .navigationTitle("🌦️ 날씨")
            .navigationBarTitleDisplayMode(.large)
        } //:NAVSTACK
    }
}

#Preview {
    MainView()
}
