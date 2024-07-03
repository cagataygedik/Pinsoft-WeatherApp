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
    
    private let cityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.numberOfLines = 1
        return label
    }()
    
    private let countryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .medium)
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
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.numberOfLines = 1
        label.textAlignment = .right
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.numberOfLines = 1
        label.textAlignment = .right
        return label
    }()
    
    private let windSpeedLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .light)
        label.numberOfLines = 1
        label.textAlignment = .right
        return label
    }()
    
    private let leftStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        stackView.spacing = 16
        return stackView
    }()
    
    private let rightStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .trailing
        stackView.distribution = .equalSpacing
        stackView.spacing = 16
        return stackView
    }()
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        return stackView
    }()
    
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
        leftStackView.addArrangedSubview(cityLabel)
        leftStackView.addArrangedSubview(countryLabel)
        leftStackView.addArrangedSubview(humidityLabel)
        
        rightStackView.addArrangedSubview(temperatureLabel)
        rightStackView.addArrangedSubview(descriptionLabel)
        rightStackView.addArrangedSubview(windSpeedLabel)
        
        mainStackView.addArrangedSubview(leftStackView)
        mainStackView.addArrangedSubview(rightStackView)
        
        contentView.addSubview(mainStackView)
    }
    
    private func setupConstraints() {
        mainStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(5)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cityLabel.text = nil
        countryLabel.text = nil
        temperatureLabel.text = nil
        descriptionLabel.text = nil
        humidityLabel.text = nil
        windSpeedLabel.text = nil
    }
    
    func configure(with weather: Weather) {
        cityLabel.text = weather.city
        countryLabel.text = weather.country
        temperatureLabel.text = "\(weather.temperature)°C"
        descriptionLabel.text = weather.weatherDescription
        humidityLabel.text = "Humudity: \(weather.humidity)%"
        windSpeedLabel.text = "Wind Speed: \(weather.windSpeed)KM/H"
    }
}
