//
//  PWWeatherViewController.swift
//  Pinsoft-WeatherApp
//
//  Created by Celil Çağatay Gedik on 2.07.2024.
//

import UIKit

final class PWWeatherListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate{
    private var searchBar: UISearchBar!
    private var collectionView: UICollectionView!
    private var viewModel: PWWeatherListViewModel = PWWeatherListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        setupSearchBar()
        configureCollectionView()
        viewModel.updateUI = { [weak self] in
            self?.collectionView.reloadData()
        }
        viewModel.fetchWeather()
        hideKeyboardWhenTappedAround()
    }
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupSearchBar() {
        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = "Search for a city"
        view.addSubview(searchBar)
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
    }
    
    private func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.frame.size.width - 16, height: 120)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PWWeatherCell.self, forCellWithReuseIdentifier: PWWeatherCell.identifier)
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let weather = viewModel.filteredWeatherData[indexPath.item]
        let detailVC = PWWeatherDetailViewController(weather: weather)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filterWeather(by: searchText)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.height * 2 {
            viewModel.fetchNextPage()
        }
    }
}
