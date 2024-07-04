//
//  PWWeatherViewController.swift
//  Pinsoft-WeatherApp
//
//  Created by Celil Çağatay Gedik on 2.07.2024.
//

import UIKit

import UIKit

final class PWWeatherListViewController: UIViewController, UISearchResultsUpdating, PWWeatherListViewDelegate {
    private var weatherListView: PWWeatherListView!
    private var searchController: UISearchController!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        setupSearchController()
        setupWeatherListView()
        hideKeyboardWhenTappedAround()
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
        weatherListView = PWWeatherListView()
        weatherListView.delegate = self
        view.addSubview(weatherListView)
        weatherListView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        weatherListView.filterWeather(by: searchText)
        UIView.transition(with: weatherListView.collectionView, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.weatherListView.collectionView.reloadData()
        }, completion: nil)
    }

    func didSelectWeather(_ weather: Weather) {
        let detailVC = PWWeatherDetailViewController(weather: weather)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
