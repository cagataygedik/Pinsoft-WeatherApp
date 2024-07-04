//
//  PWFavoritesViewController.swift
//  Pinsoft-WeatherApp
//
//  Created by Celil Çağatay Gedik on 2.07.2024.
//

import UIKit

final class PWFavoritesViewController: UIViewController, UISearchResultsUpdating, PWFavoritesViewDelegate {
    private var favoritesView = PWFavoritesView()
    private var searchController = UISearchController()
    private var viewModel = PWFavoritesViewModel.shared
    
    override func loadView() {
        view = favoritesView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        setupSearchController()
        setupFavoritesView()
        setupViewModel()
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
        favoritesView.collectionView.dataSource = self
        favoritesView.collectionView.delegate = self
        favoritesView.delegate = self
    }
    
    private func setupViewModel() {
        viewModel.updateUI = { [weak self] in
            DispatchQueue.main.async {
                self?.favoritesView.collectionView.reloadData()
            }
        }
        viewModel.loadFavorites()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        viewModel.filterFavorites(by: searchText)
        UIView.transition(with: favoritesView.collectionView, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.favoritesView.collectionView.reloadData()
        }, completion: nil)
    }
    
    func didSelectWeather(_ weather: Weather) {
        let detailVC = PWWeatherDetailViewController(weather: weather)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension PWFavoritesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.filteredFavorites.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PWWeatherCell.identifier, for: indexPath) as? PWWeatherCell else {
            return UICollectionViewCell()
        }
        let weather = viewModel.filteredFavorites[indexPath.item]
        cell.configure(with: weather)
        return cell
    }
}

extension PWFavoritesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let weather = viewModel.filteredFavorites[indexPath.item]
        didSelectWeather(weather)
    }
}


