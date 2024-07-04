//
//  Date+Extension.swift
//  Pinsoft-WeatherApp
//
//  Created by Celil Çağatay Gedik on 4.07.2024.
//

import Foundation

extension String {
    func toDisplayDateFormat(from inputFormat: String = "yyyy-MM-dd", to outputFormat: String = "dd MMMM yyyy") -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = inputFormat
        
        if let date = dateFormatter.date(from: self) {
            let displayDateFormatter = DateFormatter()
            displayDateFormatter.dateFormat = outputFormat
            return displayDateFormatter.string(from: date)
        }
        return nil
    }
}
