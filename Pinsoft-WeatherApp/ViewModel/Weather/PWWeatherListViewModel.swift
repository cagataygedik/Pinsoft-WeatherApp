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
    var paginatedWeatherData: [Weather] = []
    var updateUI: (() -> Void)?
    var isLoading = false
    var currentPage = 1
    private let itemsPerPage = 10
    let totalPages = 6
    
    init(weatherService: WeatherServiceConformable = WeatherService.shared) {
        self.weatherService = weatherService
    }
    
    func fetchWeather() {
        guard !isLoading else { return }
        isLoading = true
        weatherService.fetchWeatherData(page: currentPage) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            switch result {
            case .success(let data):
                self.weatherData = data
                self.filteredWeatherData = data
                self.currentPage = 1
                self.paginatedWeatherData.removeAll()
                self.loadNextPage()
            case .failure(let error):
                print("Failed to fetch weather data: \(error)")
            }
        }
    }
    
    func loadNextPage() {
        guard !isLoading, currentPage <= totalPages else { return }
        let startIndex = (currentPage - 1) * itemsPerPage
        let endIndex = min(startIndex + itemsPerPage, filteredWeatherData.count)
        if startIndex < endIndex {
            paginatedWeatherData.append(contentsOf: filteredWeatherData[startIndex..<endIndex])
            currentPage += 1
            updateUI?()
        } else {
            print("no more data to load.")
        }
    }
    
    func filterWeather(by searchText: String) {
        if searchText.isEmpty {
            filteredWeatherData = weatherData
        } else {
            filteredWeatherData = weatherData.filter { $0.city.lowercased().contains(searchText.lowercased()) }
        }
        currentPage = 1
        paginatedWeatherData.removeAll()
        loadNextPage()
    }
    
    func updateWeather(_ updatedWeather: Weather) {
        if let index = weatherData.firstIndex(where: { $0.id == updatedWeather.id }) {
            weatherData[index] = updatedWeather
        }
        
        if let index = filteredWeatherData.firstIndex(where: { $0.id == updatedWeather.id }) {
            filteredWeatherData[index] = updatedWeather
        }
        
        if let index = paginatedWeatherData.firstIndex(where: { $0.id == updatedWeather.id }) {
            paginatedWeatherData[index] = updatedWeather
        }
        
        updateUI?()
    }
}
