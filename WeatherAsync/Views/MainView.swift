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
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Section {
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
                    .padding(20)
                }
                
                if vm.isLoading {
                    ProgressView("불러오는 중 ...")
                        .font(.title)
                } else if let weatherInfo = vm.currentWeatherData {

                    WeatherDetailView(weatherInfo: weatherInfo, cityName: cityName)
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
        } //:NAVSTACK
    }
}

#Preview {
    MainView()
}
