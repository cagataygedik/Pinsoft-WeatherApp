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
 //           self?.sortWeatherDataByID()
            self?.weatherListView.collectionView.reloadData()
        }
        viewModel.fetchWeather()
    }
    
    private func sortWeatherDataByID() {
        viewModel.filteredWeatherData.sort { $0.id < $1.id }
    }

    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        viewModel.filterWeather(by: searchText)
        UIView.transition(with: weatherListView.collectionView, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.weatherListView.collectionView.reloadData()
        }, completion: nil)
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
        return viewModel.filteredWeatherData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PWWeatherCell.identifier, for: indexPath) as? PWWeatherCell else {
            return UICollectionViewCell()
        }
        let weather = viewModel.filteredWeatherData[indexPath.item]
        cell.configure(with: weather)
        return cell
    }
}

extension PWWeatherListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let weather = viewModel.filteredWeatherData[indexPath.item]
        didSelectWeather(weather)
    }
}
