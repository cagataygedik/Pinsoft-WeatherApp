//
//  PWFavoritesViewController.swift
//  Pinsoft-WeatherApp
//
//  Created by Celil Çağatay Gedik on 2.07.2024.
//

import UIKit

final class PWFavoritesViewController: UIViewController, UISearchResultsUpdating, PWFavoritesViewDelegate {
    private var favoritesView: PWFavoritesView!
    private var searchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        setupFavoritesView()
        setupSearchController()
        hideKeyboardWhenTappedAround()
    }
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Favorites"
    }
    
    private func setupSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for a city"
        navigationItem.searchController = searchController
    }
    
    private func setupFavoritesView() {
        favoritesView = PWFavoritesView()
        favoritesView.delegate = self
        view.addSubview(favoritesView)
        favoritesView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        favoritesView.filterFavorites(by: searchText)
        UIView.transition(with: favoritesView.collectionView, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.favoritesView.collectionView.reloadData()
        }, completion: nil)
    }
    
    func didSelectWeather(_ weather: Weather) {
        let detailVC = PWWeatherDetailViewController(weather: weather)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
