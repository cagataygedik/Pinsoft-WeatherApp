//
//  FavoritesViewModel.swift
//  Pinsoft-WeatherApp
//
//  Created by Celil Çağatay Gedik on 2.07.2024.
//

import Foundation
import CoreData

class PWFavoritesViewModel {
    static let shared = PWFavoritesViewModel()
    private var favorites: [Weather] = []
    var filteredFavorites: [Weather] = []
    var updateUI: (() -> Void )?
    
    private init() {
        loadFavorites()
        filteredFavorites = favorites
    }
    
    func addFavorite(_ weather: Weather) {
        favorites.append(weather)
        CoreDataStack.shared.saveFavoriteWeatherData(weather)
        filterFavorites(by: "")
        updateUI?()
    }
    
    func removeFavorite(_ weather: Weather) {
        if let index = favorites.firstIndex(where: { $0.id == weather.id }) {
            favorites.remove(at: index)
            CoreDataStack.shared.removeFavoriteWeatherData(weather)
            filterFavorites(by: "")
            updateUI?()
        }
    }
    
    func isFavorite(_ weather: Weather) -> Bool {
        return favorites.contains(where: { $0.id == weather.id })
    }
    
    func getFavorites() -> [Weather] {
        return favorites
    }
    
    func loadFavorites() {
        let favoriteEntities = CoreDataStack.shared.fetchFavoriteWeatherData()
        favorites = favoriteEntities.map { $0.toWeather() }
        filteredFavorites = favorites
        updateUI?()
    }
    
    func filterFavorites(by searchText: String) {
        if searchText.isEmpty {
            filteredFavorites = favorites
        } else {
            filteredFavorites = favorites.filter { $0.city.lowercased().contains(searchText.lowercased()) }
        }
        updateUI?()
    }
}
