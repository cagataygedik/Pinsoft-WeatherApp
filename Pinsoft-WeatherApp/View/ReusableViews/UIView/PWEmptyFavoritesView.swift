//
//  PWEmptyFavoritesView.swift
//  Pinsoft-WeatherApp
//
//  Created by Celil Çağatay Gedik on 12.07.2024.
//

import UIKit

final class PWEmptyFavoritesView: UIView {
    private let imageView = PWImageView(systemName: "star.fill", effect: .bounce)
    private let messageLabel = PWLabel(textAlignment: .center, fontSize: 18, fontWeight: .medium)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        addSubview(messageLabel)
        
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(100)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    private func configure() {
        messageLabel.text = "You should favorite a weather to display favorites"
        messageLabel.numberOfLines = 0
    }
}
