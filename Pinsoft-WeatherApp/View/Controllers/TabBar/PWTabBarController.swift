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
        UITabBar.appearance().tintColor = .systemCyan
        UINavigationBar.appearance().tintColor = .systemCyan
        viewControllers = [createWeatherListController(), createFavoritesController()]
    }
    
    func createWeatherListController() -> UINavigationController {
        let weatherListViewController = PWWeatherListViewController()
        weatherListViewController.title = "Weather"
        let tabBarItem = UITabBarItem(title: "Weather", image: UIImage(systemName: "cloud.sun.fill"), tag: 0)
        weatherListViewController.tabBarItem = tabBarItem
        return UINavigationController(rootViewController: weatherListViewController)
    }
    
    func createFavoritesController() -> UINavigationController {
        let favoritesViewController = PWFavoritesViewController()
        favoritesViewController.title = "Favorites"
        let tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "star.fill"), tag: 1)
        favoritesViewController.tabBarItem = tabBarItem
        return UINavigationController(rootViewController: favoritesViewController)
    }
    
    
    /*
    private func configureTabBar() {
        UITabBar.appearance().tintColor = .systemCyan
        UINavigationBar.appearance().tintColor = .systemCyan
        
        let weatherListViewController = PWWeatherListViewController()
        let favoritesViewControler = PWFavoritesViewController()
        
        let navWeatherListViewController = UINavigationController(rootViewController: weatherListViewController)
        let navFavoritesViewController = UINavigationController(rootViewController: favoritesViewControler)
        
        weatherListViewController.navigationItem.largeTitleDisplayMode = .always
        favoritesViewControler.navigationItem.largeTitleDisplayMode = .always
        
        navWeatherListViewController.tabBarItem = UITabBarItem(title: "Weather", image: UIImage(systemName: "cloud.sun.fill"), tag: 1)
        navFavoritesViewController.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "star.fill"), tag: 2)
        
        navWeatherListViewController.navigationBar.prefersLargeTitles = true
        navFavoritesViewController.navigationBar.prefersLargeTitles = true
        
        setViewControllers([navWeatherListViewController, navFavoritesViewController], animated: true)
    }
     */
}
