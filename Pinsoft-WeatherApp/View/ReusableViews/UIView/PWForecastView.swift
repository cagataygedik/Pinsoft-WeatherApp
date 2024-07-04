//
//  PWWeatherListView.swift
//  Pinsoft-WeatherApp
//
//  Created by Celil Çağatay Gedik on 3.07.2024.
//

import UIKit

final class PWForecastView: UIView {
    
    private let dayLabel = PWLabel(textAlignment: .center, fontSize: 16, fontWeight: .semibold)
    private let descriptionLabel = PWLabel(textAlignment: .center, fontSize: 14, fontWeight: .regular)
    private let temperatureLabel = PWLabel(textAlignment: .center, fontSize: 16, fontWeight: .regular)
    private let stackView = PWStackView(axis: .vertical, alignment: .center, distribution: .equalSpacing, spacing: 5)
    
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
        addSubview(stackView)
        stackView.addArrangedSubview(dayLabel)
        stackView.addArrangedSubview(descriptionLabel)
        stackView.addArrangedSubview(temperatureLabel)
    }
    
    private func setupConstraints() {
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
    }
    
    func configure(day: String, description: String, temperature: String) {
        dayLabel.text = day
        descriptionLabel.text = description
        temperatureLabel.text = temperature
    }
}
