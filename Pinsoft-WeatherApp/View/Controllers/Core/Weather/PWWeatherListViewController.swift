//
//  PWWeatherViewController.swift
//  Pinsoft-WeatherApp
//
//  Created by Celil Çağatay Gedik on 2.07.2024.
//

import UIKit

final class PWWeatherListViewController: UIViewController, UISearchResultsUpdating, PWWeatherListViewDelegate, PWWeatherDetailDelegate {
    private let weatherListView = PWWeatherListView()
    private var searchController = UISearchController()
    private let viewModel = PWWeatherListViewModel()
    
    override func loadView() {
        view = weatherListView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        setupSearchController()
        setupWeatherListView()
        setupViewModel()
        setupNotificationCenter()
    }
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    private func setupSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for a city"
        navigationItem.searchController = searchController
    }
    
    private func setupWeatherListView() {
        weatherListView.delegate = self
        weatherListView.collectionView.dataSource = self
        weatherListView.collectionView.delegate = self
    }
    
    private func setupViewModel() {
        viewModel.updateUI = { [weak self] in
            self?.weatherListView.collectionView.reloadData()
        }
        viewModel.showError = { [weak self] error in
            self?.showErrorAlert(with: error)
        }
        
        viewModel.fetchWeather()
    }
    
    private func showErrorAlert(with error: PWError) {
        DispatchQueue.main.async {
            let alertViewController = PWAlertViewController(title: "😭Something went wrong😭", message: error.localizedDescription)
            alertViewController.modalPresentationStyle = .overFullScreen
            alertViewController.modalTransitionStyle = .crossDissolve
            alertViewController.retryAction = { [weak self] in
                self?.viewModel.fetchWeather()
            }
            self.present(alertViewController, animated: true, completion: nil)
        }
    }
    
    private func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleFavoritesUpdated(notification:)), name: NSNotification.Name("FavoritesUpdated"), object: nil)
    }
    
    @objc private func handleFavoritesUpdated(notification: Notification) {
        if let updatedWeather = notification.userInfo?["updatedWeather"] as? Weather {
            viewModel.updateWeather(updatedWeather)
            weatherListView.collectionView.reloadData()
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        viewModel.filterWeather(by: searchText)
        weatherListView.collectionView.animateSearchingState {
            self.weatherListView.collectionView.reloadData()
        }
    }
    
    func didSelectWeather(_ weather: Weather) {
        let detailViewController = PWWeatherDetailViewController(weather: weather)
        detailViewController.delegate = self
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func didUpdateFavoriteStatus(for weather: Weather) {
        viewModel.updateWeather(weather)
        weatherListView.collectionView.reloadData()
    }
}

extension PWWeatherListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.paginatedWeatherData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PWWeatherCell.identifier, for: indexPath) as? PWWeatherCell else {
            return UICollectionViewCell()
        }
        let weather = viewModel.paginatedWeatherData[indexPath.item]
        cell.configure(with: weather)
        return cell
    }
}

extension PWWeatherListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let weather = viewModel.paginatedWeatherData[indexPath.item]
        didSelectWeather(weather)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height, viewModel.currentPage <= viewModel.totalPages {
            viewModel.loadNextPage()
        }
    }
}

