//
//  PWImageView.swift
//  Pinsoft-WeatherApp
//
//  Created by Celil Çağatay Gedik on 3.07.2024.
//

import UIKit

final class PWImageView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(systemName: String) {
        self.init(frame: .zero)
        setSymbolImage(systemName: systemName)
    }
    
    private func configure() {
        tintColor = .label
        translatesAutoresizingMaskIntoConstraints = false
        contentMode = .scaleAspectFit
    }
    
}
