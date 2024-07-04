//
//  PWWeatherListView.swift
//  Pinsoft-WeatherApp
//
//  Created by Celil Çağatay Gedik on 4.07.2024.
//

import UIKit

protocol PWWeatherListViewDelegate: AnyObject {
    func didSelectWeather(_ weather: Weather)
}

final class PWWeatherListView: UIView {
    var collectionView: UICollectionView!
    private var viewModel: PWWeatherListViewModel = PWWeatherListViewModel()
    weak var delegate: PWWeatherListViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCollectionView()
        viewModel.updateUI = { [weak self] in
            self?.collectionView.reloadData()
        }
        viewModel.fetchWeather()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 16, height: 120)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(PWWeatherCell.self, forCellWithReuseIdentifier: PWWeatherCell.identifier)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func filterWeather(by searchText: String) {
        viewModel.filterWeather(by: searchText)
    }
}

extension PWWeatherListView: UICollectionViewDataSource {
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

extension PWWeatherListView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let weather = viewModel.filteredWeatherData[indexPath.item]
        delegate?.didSelectWeather(weather)
    }
}

