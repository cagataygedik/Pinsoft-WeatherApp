//
//  PWTabBarController.swift
//  Pinsoft-WeatherApp
//
//  Created by Celil Çağatay Gedik on 2.07.2024.
//

import UIKit

final class PWTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBar()
    }
    
    private func configureTabBar() {
        viewControllers = [createWeatherListController(), createFavoritesController()]
    }
    
    func createWeatherListController() -> UINavigationController {
        let weatherListViewController = PWWeatherListViewController()
        weatherListViewController.title = "Weather"
        let tabBarItem = UITabBarItem(title: "Weather", image: UIImage(systemName: "cloud.sun"), tag: 0)
        weatherListViewController.tabBarItem = tabBarItem
        return UINavigationController(rootViewController: weatherListViewController)
    }
    
    func createFavoritesController() -> UINavigationController {
        let favoritesViewController = PWFavoritesViewController()
        favoritesViewController.title = "Favorites"
        let tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "star"), tag: 1)
        favoritesViewController.tabBarItem = tabBarItem
        return UINavigationController(rootViewController: favoritesViewController)
    }
}
