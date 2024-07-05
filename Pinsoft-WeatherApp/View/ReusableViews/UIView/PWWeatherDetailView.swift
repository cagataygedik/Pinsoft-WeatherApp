//
//  PWWeatherDetailView.swift
//  Pinsoft-WeatherApp
//
//  Created by Celil Çağatay Gedik on 5.07.2024.
//

import UIKit

final class PWWeatherDetailView: UIView {
    let cityLabel = PWLabel(textAlignment: .center, fontSize: 40, fontWeight: .semibold)
    let countryLabel = PWLabel(textAlignment: .center, fontSize: 20, fontWeight: .medium)
    let temperatureLabel = PWLabel(textAlignment: .center, fontSize: 40, fontWeight: .semibold)
    let weatherDescriptionLabel = PWLabel(textAlignment: .center, fontSize: 20, fontWeight: .medium)
    let humidityLabel = PWLabel(textAlignment: .left, fontSize: 16, fontWeight: .light)
    let windSpeedLabel = PWLabel(textAlignment: .right, fontSize: 16, fontWeight: .light)
    
    let temperatureImageView = PWImageView(systemName: "thermometer.high")
    let weatherDescriptionImageView = PWImageView(systemName: "cloud")
    let humidityImageView = PWImageView(systemName: "humidity.fill")
    let windSpeedImageView = PWImageView(systemName: "wind")
    
    let temperatureStackView = PWStackView(axis: .horizontal, alignment: .center, distribution: .equalSpacing, spacing: 5)
    let weatherDescriptionStackView = PWStackView(axis: .vertical, alignment: .center, distribution: .equalSpacing, spacing: 5)
    let humidityStackView = PWStackView(axis: .horizontal, alignment: .center, distribution: .equalSpacing, spacing: 5)
    let windSpeedStackView = PWStackView(axis: .horizontal, alignment: .center, distribution: .equalSpacing, spacing: 5)
    let verticalStackView = PWStackView(axis: .vertical, alignment: .center, distribution: .equalSpacing, spacing: 40)
    let horizontalStackView = PWStackView(axis: .horizontal, alignment: .center, distribution: .equalSpacing, spacing: 180)
    let forecastContainerView = PWStackView(axis: .horizontal, alignment: .center, distribution: .fillEqually, spacing: 10)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        temperatureStackView.addArrangedSubview(temperatureImageView)
        temperatureStackView.addArrangedSubview(temperatureLabel)
        
        weatherDescriptionStackView.addArrangedSubview(weatherDescriptionImageView)
        weatherDescriptionStackView.addArrangedSubview(weatherDescriptionLabel)
        
        humidityStackView.addArrangedSubview(humidityImageView)
        humidityStackView.addArrangedSubview(humidityLabel)
        
        windSpeedStackView.addArrangedSubview(windSpeedImageView)
        windSpeedStackView.addArrangedSubview(windSpeedLabel)
        
        verticalStackView.addArrangedSubview(cityLabel)
        verticalStackView.addArrangedSubview(countryLabel)
        verticalStackView.addArrangedSubview(temperatureStackView)
        verticalStackView.addArrangedSubview(weatherDescriptionStackView)
        verticalStackView.addArrangedSubview(horizontalStackView)
        
        horizontalStackView.addArrangedSubview(humidityStackView)
        horizontalStackView.addArrangedSubview(windSpeedStackView)
        
        verticalStackView.addArrangedSubview(forecastContainerView)
        
        addSubview(verticalStackView)
    }
    
    private func setupConstraints() {
        verticalStackView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(5)
            make.left.equalTo(safeAreaLayoutGuide.snp.left).offset(5)
            make.right.equalTo(safeAreaLayoutGuide.snp.right).offset(-5)
            make.bottom.lessThanOrEqualTo(safeAreaLayoutGuide.snp.bottom).offset(-10)
        }
        
        temperatureImageView.snp.makeConstraints { make in
            make.width.height.equalTo(temperatureLabel.snp.height)
        }
        
        weatherDescriptionImageView.snp.makeConstraints { make in
            make.width.height.equalTo(80)
        }
    }
}
