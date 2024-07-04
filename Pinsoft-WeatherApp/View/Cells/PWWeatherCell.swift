//
//  PWWeatherCell.swift
//  Pinsoft-WeatherApp
//
//  Created by Celil Çağatay Gedik on 2.07.2024.
//

import UIKit
import SnapKit

final class PWWeatherCell: UICollectionViewCell {
    static let identifier = "PWWeatherCell"
    
    private let cityLabel = PWLabel(textAlignment: .left, fontSize: 20, fontWeight: .semibold)
    private let countryLabel = PWLabel(textAlignment: .left, fontSize: 18, fontWeight: .medium)
    private let humidityLabel = PWLabel(textAlignment: .left, fontSize: 16, fontWeight: .light)
    private let temperatureLabel = PWLabel(textAlignment: .right, fontSize: 20, fontWeight: .semibold)
    private let weatherDescriptionLabel = PWLabel(textAlignment: .right, fontSize: 18, fontWeight: .medium)
    private let windSpeedLabel = PWLabel(textAlignment: .right, fontSize: 16, fontWeight: .light)
    
    private let humidityImageView = PWImageView(systemName: "humidity")
    private let temperatureImageView = PWImageView(systemName: "thermometer.medium")
    private let windSpeedImageView = PWImageView(systemName: "wind")
    private let weatherDescriptionImageView = PWImageView(systemName: "cloud")
    
    private let humidityStackView = PWStackView(axis: .horizontal, alignment: .center, distribution: .equalSpacing, spacing: 5)
    private let temperatureStackView = PWStackView(axis: .horizontal, alignment: .center, distribution: .equalSpacing, spacing: 5)
    private let windSpeedStackView = PWStackView(axis: .horizontal, alignment: .center, distribution: .equalSpacing, spacing: 5)
    private let weatherDesciptionStackView = PWStackView(axis: .horizontal, alignment: .center, distribution: .equalSpacing, spacing: 5)
    private let leftStackView = PWStackView(axis: .vertical, alignment: .leading, distribution: .equalSpacing, spacing: 16)
    private let rightStackView = PWStackView(axis: .vertical, alignment: .trailing, distribution: .equalSpacing, spacing: 16)
    private let mainStackView = PWStackView(axis: .horizontal, alignment: .center, distribution: .fillEqually, spacing: 16)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayer()
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayer() {
        contentView.backgroundColor = .systemBackground
        contentView.layer.cornerRadius = 8
        contentView.layer.borderColor = UIColor.systemCyan.cgColor
        contentView.layer.borderWidth = 2
    }
    
    private func addSubviews() {
        humidityStackView.addArrangedSubview(humidityImageView)
        humidityStackView.addArrangedSubview(humidityLabel)
        
        windSpeedStackView.addArrangedSubview(windSpeedImageView)
        windSpeedStackView.addArrangedSubview(windSpeedLabel)
        
        temperatureStackView.addArrangedSubview(temperatureImageView)
        temperatureStackView.addArrangedSubview(temperatureLabel)
        
        weatherDesciptionStackView.addArrangedSubview(weatherDescriptionImageView)
        weatherDesciptionStackView.addArrangedSubview(weatherDescriptionLabel)
        
        leftStackView.addArrangedSubview(cityLabel)
        leftStackView.addArrangedSubview(countryLabel)
        leftStackView.addArrangedSubview(humidityStackView)
        
        rightStackView.addArrangedSubview(temperatureStackView)
        rightStackView.addArrangedSubview(weatherDesciptionStackView)
        rightStackView.addArrangedSubview(windSpeedStackView)
        
        mainStackView.addArrangedSubview(leftStackView)
        mainStackView.addArrangedSubview(rightStackView)
        
        contentView.addSubview(mainStackView)
    }
    
    private func setupConstraints() {
        mainStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(12)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cityLabel.text = nil
        countryLabel.text = nil
        temperatureLabel.text = nil
        weatherDescriptionLabel.text = nil
        humidityLabel.text = nil
        windSpeedLabel.text = nil
    }
    
    func configure(with weather: Weather) {
        cityLabel.text = weather.city
        countryLabel.text = weather.country
        temperatureLabel.text = "\(weather.temperature)°C"
        weatherDescriptionLabel.text = weather.weatherDescription
        humidityLabel.text = "\(weather.humidity)%"
        windSpeedLabel.text = "\(weather.windSpeed)KM/H"
        
        if let weatherDescription = WeatherDescription(rawValue: weather.weatherDescription) {
            weatherDescriptionImageView.image = UIImage(systemName: weatherDescription.imageName)
        }
    }
}
