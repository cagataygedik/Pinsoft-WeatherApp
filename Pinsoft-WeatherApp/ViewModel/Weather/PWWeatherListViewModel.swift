//
//  PWWeatherListViewModel.swift
//  Pinsoft-WeatherApp
//
//  Created by Celil Çağatay Gedik on 2.07.2024.
//

import Foundation

final class PWWeatherListViewModel {
    private var weatherService: WeatherService
    var weatherData: [Weather] = []
    var filteredWeatherData: [Weather] = []
    var updateUI: (() -> Void)?
    var isLoading = false
    
    init(weatherService: WeatherService = WeatherService.shared) {
        self.weatherService = weatherService
    }
    
    func fetchWeather() {
        guard !isLoading else { return }
        isLoading = true
        weatherService.fetchWeatherData { [weak self] result in
            switch result {
            case .success(let data):
                self?.weatherData = data
                self?.filteredWeatherData  = data
                self?.updateUI?()
            case .failure(let error):
                print(error)
            }
            self?.isLoading = false
        }
    }
    
    func fetchNextPage() {
        guard !isLoading else { return }
        isLoading = true
        weatherService.fetchNextPage { [weak self] result in
            switch result {
            case .success(let data):
                self?.weatherData.append(contentsOf: data)
                self?.filteredWeatherData = self?.weatherData ?? []
                self?.updateUI?()
            case .failure(let error):
                print(error)
            }
            self?.isLoading = false
        }
    }
    
    func filterWeather(by searchText: String) {
        if searchText.isEmpty {
            filteredWeatherData = weatherData
        } else {
            filteredWeatherData = weatherData.filter({ $0.city.lowercased().contains(searchText.lowercased()) })
        }
        updateUI?()
    }
}
