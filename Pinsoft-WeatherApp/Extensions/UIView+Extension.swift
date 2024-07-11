//
//  UIView+Extension.swift
//  Pinsoft-WeatherApp
//
//  Created by Celil Çağatay Gedik on 11.07.2024.
//

import UIKit

extension UIView {
    func animateSearchingState(withDuration duration: TimeInterval = 0.3, options: UIView.AnimationOptions = .transitionCrossDissolve, animations: @escaping () -> Void, completion: ((Bool) -> Void)? = nil) {
        UIView.transition(with: self, duration: duration, options: options, animations: animations, completion: completion)
    }
}

