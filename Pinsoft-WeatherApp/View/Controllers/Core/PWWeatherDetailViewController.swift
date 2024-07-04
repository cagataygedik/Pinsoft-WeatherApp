//
//  PWWeatherDetailViewController.swift
//  Pinsoft-WeatherApp
//
//  Created by Celil Çağatay Gedik on 2.07.2024.
//

import UIKit
import SnapKit

final class PWWeatherDetailViewController: UIViewController {
    private var weather: Weather
    
    private let cityLabel = PWLabel(textAlignment: .center, fontSize: 40, fontWeight: .semibold)
    private let countryLabel = PWLabel(textAlignment: .center, fontSize: 20, fontWeight: .medium)
    private let temperatureLabel = PWLabel(textAlignment: .center, fontSize: 40, fontWeight: .semibold)
    private let weatherDescriptionLabel = PWLabel(textAlignment: .center, fontSize: 20, fontWeight: .medium)
    private let humidityLabel = PWLabel(textAlignment: .left, fontSize: 16, fontWeight: .light)
    private let windSpeedLabel = PWLabel(textAlignment: .right, fontSize: 16, fontWeight: .light)
    
    private let temperatureImageView = PWImageView(systemName: "thermometer.high")
    private let weatherDescriptionImageView = PWImageView(systemName: "cloud")
    private let humidityImageView = PWImageView(systemName: "humidity.fill")
    private let windSpeedImageView = PWImageView(systemName: "wind")
    
    private let temperatureStackView = PWStackView(axis: .horizontal, alignment: .center, distribution: .equalSpacing, spacing: 5)
    private let weatherDescriptionStackView = PWStackView(axis: .vertical, alignment: .center, distribution: .equalSpacing, spacing: 5)
    private let humidityStackView = PWStackView(axis: .horizontal, alignment: .center, distribution: .equalSpacing, spacing: 5)
    private let windSpeedStackView = PWStackView(axis: .horizontal, alignment: .center, distribution: .equalSpacing, spacing: 5)
    private let verticalStackView = PWStackView(axis: .vertical, alignment: .center, distribution: .equalSpacing, spacing: 40)
    private let horizontalStackView = PWStackView(axis: .horizontal, alignment: .center, distribution: .equalSpacing, spacing: 180)
    private let forecastContainerView = PWStackView(axis: .horizontal, alignment: .center, distribution: .fillEqually, spacing: 10)
    
    init(weather: Weather) {
        self.weather = weather
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addSubviews()
        setupUI()
        configureUI()
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        let favoriteButton = UIBarButtonItem(image: UIImage(systemName: isFavorite() ? "star.fill" : "star"), style: .plain, target: self, action: #selector(toggleFavorite))
        navigationItem.rightBarButtonItem = favoriteButton
    }
    
    @objc private func toggleFavorite() {
        weather.isFavorite.toggle()
        if weather.isFavorite {
            PWFavoritesViewModel.shared.removeFavorite(weather)
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: "star")
            showAlert(title: "Removed from favorites", message: "\(weather.city) has been removed from favorites")
        } else {
            PWFavoritesViewModel.shared.addFavorite(weather)
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: "star.fill")
            showAlert(title: "Added to favorites", message: "\(weather.city) has been added to favorites")
        }
        NotificationCenter.default.post(name: NSNotification.Name("FavoritesUpdated"), object: nil)
    }
    
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func isFavorite() -> Bool {
        return PWFavoritesViewModel.shared.isFavorite(weather)
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
        
        view.addSubview(verticalStackView)
    }
    
    private func setupUI() {
        verticalStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(5)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(5)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(-5)
            make.bottom.lessThanOrEqualTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
        }
        
        temperatureImageView.snp.makeConstraints { make in
            make.width.height.equalTo(temperatureLabel.snp.height)
        }
        
        weatherDescriptionImageView.snp.makeConstraints { make in
            make.width.height.equalTo(80)
        }
    }
    
    private func configureUI() {
        cityLabel.text = weather.city
        countryLabel.text = weather.country
        temperatureLabel.text = "\(weather.temperature)°C"
        weatherDescriptionLabel.text = weather.weatherDescription
        humidityLabel.text = "\(weather.humidity)%"
        windSpeedLabel.text = "\(weather.windSpeed)KM/H"
        
        forecastContainerView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for forecast in weather.forecast.prefix(2) {
            let forecastView = PWForecastView()
            forecastView.configure(day: forecast.date.toDisplayDateFormat() ?? forecast.date, description: forecast.weatherDescription, temperature: "\(forecast.temperature)°C")
            forecastContainerView.addArrangedSubview(forecastView)
        }
        
        if let weatherDescription = WeatherDescription(rawValue: weather.weatherDescription) {
            weatherDescriptionImageView.setSymbolImage(systemName: weatherDescription.imageName)
            view.backgroundColor = weatherDescription.backgroundColor
        }
    }
}
