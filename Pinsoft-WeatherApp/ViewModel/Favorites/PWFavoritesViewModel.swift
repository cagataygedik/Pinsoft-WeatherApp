//
//  FavoritesViewModel.swift
//  Pinsoft-WeatherApp
//
//  Created by Celil Çağatay Gedik on 2.07.2024.
//

import Foundation

class PWFavoritesViewModel {
    private var favorites: [Weather] = []
    
    func addFavorite(_ weather: Weather) {
        favorites.append(weather)
    }
    
    func removeFavorite(_ weather: Weather) {
        if let index = favorites.firstIndex(where: { $0.id == weather.id }) {
            favorites.remove(at: index)
        }
    }
    
    func getFavorites() -> [Weather] {
        return favorites
    }
}
