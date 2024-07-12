//
//  PWFavoritesViewController.swift
//  Pinsoft-WeatherApp
//
//  Created by Celil Çağatay Gedik on 2.07.2024.
//

import UIKit

final class PWFavoritesViewController: UIViewController, UISearchResultsUpdating, PWFavoritesViewDelegate, PWWeatherDetailDelegate {
    private let favoritesView = PWFavoritesView()
    private let emptyFavoritesView = PWEmptyFavoritesView()
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
        setupEmptyFavoritesView()
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
                self?.updateEmptyState()
            }
        }
        viewModel.loadFavorites()
    }
    
    private func setupEmptyFavoritesView() {
        view.addSubview(emptyFavoritesView)
        emptyFavoritesView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        updateEmptyState()
    }
    
    private func updateEmptyState() {
        let isEmpty = viewModel.isEmpty && !searchController.isActive
        emptyFavoritesView.isHidden = !isEmpty
        navigationItem.searchController = isEmpty ? nil : searchController
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        viewModel.filterFavorites(by: searchText)
        favoritesView.collectionView.animateSearchingState {
            self.favoritesView.collectionView.reloadData()
        }
    }
    
    func didSelectWeather(_ weather: Weather) {
        let detailViewController = PWWeatherDetailViewController(weather: weather)
        detailViewController.delegate = self
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func didUpdateFavoriteStatus(for weather: Weather) {
        viewModel.loadFavorites()
        DispatchQueue.main.async {
            self.favoritesView.collectionView.reloadData()
        }
        NotificationCenter.default.post(name: NSNotification.Name("FavoritesUpdated"), object: nil, userInfo: ["updatedWeather": weather])
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


