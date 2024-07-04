//
//  PWWeatherListView.swift
//  Pinsoft-WeatherApp
//
//  Created by Celil Çağatay Gedik on 3.07.2024.
//

import UIKit

final class PWForecastView: UIView {
    
    private let dayLabel = PWLabel(textAlignment: .center, fontSize: 16, fontWeight: .semibold)
    private let weatherDescriptionLabel = PWLabel(textAlignment: .center, fontSize: 14, fontWeight: .regular)
    private let temperatureLabel = PWLabel(textAlignment: .center, fontSize: 16, fontWeight: .regular)
    
    private let weatherDescriptionImageView = PWImageView(systemName: "cloud")
    
    private let weatherDescriptionStackView = PWStackView(axis: .horizontal, alignment: .center, distribution: .equalSpacing, spacing: 2)
    private let mainStackView = PWStackView(axis: .vertical, alignment: .center, distribution: .equalSpacing, spacing: 5)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .systemBackground
        layer.cornerRadius = 8
        layer.borderColor = UIColor.systemCyan.cgColor
        layer.borderWidth = 2
    }
    
    private func addSubviews() {
        addSubview(mainStackView)
        
        weatherDescriptionStackView.addArrangedSubview(weatherDescriptionImageView)
        weatherDescriptionStackView.addArrangedSubview(weatherDescriptionLabel)
        
        mainStackView.addArrangedSubview(dayLabel)
        mainStackView.addArrangedSubview(weatherDescriptionStackView)
        mainStackView.addArrangedSubview(temperatureLabel)
    }
    
    private func setupConstraints() {
        mainStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
    }
    
    func configure(day: String, description: String, temperature: String) {
        dayLabel.text = day
        weatherDescriptionLabel.text = description
        temperatureLabel.text = temperature
        
        if let weatherDesciption = WeatherDescription(rawValue: description) {
            weatherDescriptionImageView.image = UIImage(systemName: weatherDesciption.imageName)
        }
    }
}
