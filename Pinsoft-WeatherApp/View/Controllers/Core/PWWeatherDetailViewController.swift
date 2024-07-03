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
    
    private let cityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 40, weight: .semibold)
        label.numberOfLines = 1
        return label
    }()
    
    private let countryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.numberOfLines = 1
        return label
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 40, weight: .semibold)
        label.numberOfLines = 1
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.numberOfLines = 1
        return label
    }()
    
    private let humidityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .light)
        label.numberOfLines = 1
        return label
    }()
    
    private let windSpeedLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .light)
        label.numberOfLines = 1
        return label
    }()
    
    private let verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 60
        return stackView
    }()
    
    private let horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 70
        return stackView
    }()
    
    private let forecastContainerView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()
    
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
        verticalStackView.addArrangedSubview(cityLabel)
        verticalStackView.addArrangedSubview(countryLabel)
        verticalStackView.addArrangedSubview(temperatureLabel)
        verticalStackView.addArrangedSubview(descriptionLabel)
        verticalStackView.addArrangedSubview(horizontalStackView)
        
        horizontalStackView.addArrangedSubview(humidityLabel)
        horizontalStackView.addArrangedSubview(windSpeedLabel)
        
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
    }
    
    private func configureUI() {
        cityLabel.text = weather.city
        countryLabel.text = weather.country
        temperatureLabel.text = "\(weather.temperature)°C"
        descriptionLabel.text = weather.weatherDescription
        humidityLabel.text = "Humidity: \(weather.humidity)%"
        windSpeedLabel.text = "Wind Speed: \(weather.windSpeed)KM/H"
        
        forecastContainerView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for forecast in weather.forecast.prefix(2) {
            let forecastView = PWForecastView()
            forecastView.configure(day: forecast.date, description: forecast.weatherDescription, temperature: "\(forecast.temperature)°C")
            forecastContainerView.addArrangedSubview(forecastView)
        }
    }
}
