//
//  PWWeatherListViewModel.swift
//  Pinsoft-WeatherApp
//
//  Created by Celil Çağatay Gedik on 2.07.2024.
//

import Foundation

final class PWWeatherListViewModel {
    private let weatherService: WeatherServiceConformable
    var weatherData: [Weather] = []
    var filteredWeatherData: [Weather] = []
    var updateUI: (() -> Void)?
    var isLoading = false
    
    init(weatherService: WeatherServiceConformable = WeatherService.shared) {
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
    
    func updateWeather(_ updatedWeather: Weather) {
        if let index = weatherData.firstIndex(where: { $0.id == updatedWeather.id }) {
            weatherData[index] = updatedWeather
        }
        
        if let index = filteredWeatherData.firstIndex(where: { $0.id == updatedWeather.id }) {
            filteredWeatherData[index] = updatedWeather
        }
        
        updateUI?()
    }
}
