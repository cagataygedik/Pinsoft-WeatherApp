//
//  FavoritesViewModel.swift
//  Pinsoft-WeatherApp
//
//  Created by Celil Çağatay Gedik on 2.07.2024.
//

import Foundation
import CoreData

final class PWFavoritesViewModel {
    static let shared = PWFavoritesViewModel(coreDataStack: CoreDataStack.shared)
    private let coreDataStack: CoreDataStackConformable
    private var favorites: [Weather] = []
    var filteredFavorites: [Weather] = []
    var updateUI: (() -> Void )?
    var isEmpty: Bool { return filteredFavorites.isEmpty }
    
    init(coreDataStack: CoreDataStackConformable) {
        self.coreDataStack = coreDataStack
        loadFavorites()
        filteredFavorites = favorites
    }
    
    func addFavorite(_ weather: Weather) {
        if !favorites.contains(where: { $0.id == weather.id }) {
            favorites.append(weather)
            coreDataStack.saveFavoriteWeatherData(weather)
            filterFavorites(by: "")
            updateUI?()
        }
    }

    func removeFavorite(_ weather: Weather) {
        if let index = favorites.firstIndex(where: { $0.id == weather.id }) {
            favorites.remove(at: index)
            coreDataStack.removeFavoriteWeatherData(weather)
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
