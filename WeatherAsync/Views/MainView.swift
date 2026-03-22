//
//  MainView.swift
//  WeatherAsync
//
//  Created by YoonieMac on 3/22/26.
//

import SwiftUI

struct MainView: View {
    
    @State private var vm: WeatherViewModel = .init()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Section {
                    HStack(spacing: 10) {
                        Button("", systemImage: "magnifyingglass") {
                            Task {
                                await vm.fetchWeatherData(cityName: vm.cityName)
                            }
                        }
                        .font(.title)
                        TextField("도시 검색", text: $vm.cityName)
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
                } else if let weatherInfo = vm.weatherData {

                    WeatherDetailView(weatherInfo: weatherInfo, cityName: vm.cityName)

                } else {
                    ContentUnavailableView("네트워크 오류", systemImage: "exclamationmark.triangle", description: Text("날씨를 불러 올 수 없어요").font(.title3))
                    Button(action: {
                        Task {
                            await vm.fetchWeatherData(cityName: vm.cityName)
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
