//
//  PWWeatherDetailViewController.swift
//  Pinsoft-WeatherApp
//
//  Created by Celil Çağatay Gedik on 2.07.2024.
//

import UIKit
import SnapKit

final class PWWeatherDetailViewController: UIViewController {
    private let weatherDetailView = PWWeatherDetailView()
    private var viewModel: PWWeatherDetailViewModel
    weak var delegate: PWWeatherDetailDelegate?
    
    init(weather: Weather, favoritesViewModel: PWFavoritesViewModel = PWFavoritesViewModel.shared) {
        self.viewModel = PWWeatherDetailViewModel(weather: weather, favoritesViewModel: favoritesViewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = weatherDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        configureUI()
    }
    
    private func setupNavigationBar() {
        let favoriteButton = UIBarButtonItem(image: UIImage(systemName: viewModel.isFavorite ? "star.fill" : "star"), style: .plain, target: self, action: #selector(toggleFavorite))
        navigationItem.rightBarButtonItem = favoriteButton
    }
    
    @objc private func toggleFavorite() {
        viewModel.toggleFavorite()
        navigationItem.rightBarButtonItem?.image = UIImage(systemName: viewModel.isFavorite ? "star.fill" : "star")
 //       showAlert(title: viewModel.isFavorite ? "Added to favorites" : "Removed from favorites", message: "\(viewModel.city) has been \(viewModel.isFavorite ? "added to" : "removed from") favorites")
        delegate?.didUpdateFavoriteStatus(for: viewModel.weather)
    }
    
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func configureUI() {
        weatherDetailView.cityLabel.text = viewModel.city
        weatherDetailView.countryLabel.text = viewModel.country
        weatherDetailView.temperatureLabel.text = "\(viewModel.temperature)"
        weatherDetailView.weatherDescriptionLabel.text = viewModel.weatherDescription
        weatherDetailView.humidityLabel.text = "\(viewModel.humidity)"
        weatherDetailView.windSpeedLabel.text = "\(viewModel.windSpeed)"
        
        weatherDetailView.forecastContainerView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for forecast in viewModel.forecast {
            let forecastView = PWForecastView()
            forecastView.configure(day: forecast.date.toDisplayDateFormat() ?? forecast.date, description: forecast.weatherDescription, temperature: "\(forecast.temperature)°C")
            weatherDetailView.forecastContainerView.addArrangedSubview(forecastView)
        }
        
        if let weatherDescription = WeatherDescription(rawValue: viewModel.weatherDescription) {
            weatherDetailView.weatherDescriptionImageView.setSymbolImage(systemName: weatherDescription.imageName)
            weatherDetailView.backgroundColor = weatherDescription.backgroundColor
        }
    }
}
