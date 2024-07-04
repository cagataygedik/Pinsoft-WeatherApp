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
    weak var delegate: PWFavoritesViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCollectionView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 16, height: 120)

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(PWWeatherCell.self, forCellWithReuseIdentifier: PWWeatherCell.identifier)
        addSubview(collectionView)

        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
