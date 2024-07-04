//
//  UIImageView+Extension.swift
//  Pinsoft-WeatherApp
//
//  Created by Celil Çağatay Gedik on 4.07.2024.
//

import UIKit

extension UIImageView {
    func setSymbolImage(systemName: String) {
        let image = UIImage(systemName: systemName)
        let config = UIImage.SymbolConfiguration.preferringMulticolor()
        self.image = image?.withConfiguration(config)
    }
}
