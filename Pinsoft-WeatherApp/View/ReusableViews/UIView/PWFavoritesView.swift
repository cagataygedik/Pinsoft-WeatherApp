//
//  PWFavoritesView.swift
//  Pinsoft-WeatherApp
//
//  Created by Celil Çağatay Gedik on 4.07.2024.
//

import UIKit

protocol PWFavoritesViewDelegate: AnyObject {
    func didSelectWeather(_ weather: Weather)
}

final class PWFavoritesView: UIView {

    var collectionView: UICollectionView!
    private var viewModel = PWFavoritesViewModel.shared
    weak var delegate: PWFavoritesViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCollectionView()
        setupViewModel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 16, height: 120)

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(PWWeatherCell.self, forCellWithReuseIdentifier: PWWeatherCell.identifier)
        
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func setupViewModel() {
        viewModel.updateUI = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
        viewModel.loadFavorites()
    }

    func filterFavorites(by searchText: String) {
        viewModel.filterFavorites(by: searchText)
    }
}

extension PWFavoritesView: UICollectionViewDataSource {
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

extension PWFavoritesView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let weather = viewModel.filteredFavorites[indexPath.item]
        delegate?.didSelectWeather(weather)
    }
}


