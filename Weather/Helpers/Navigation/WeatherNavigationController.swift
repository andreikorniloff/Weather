//
//  WeatherNavigationController.swift
//  Weather
//
//  Created by Andrei Kornilov on 03.10.2021.
//

import UIKit

final class WeatherNavigationController: UINavigationController {
    
    // MARK: Initialization
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Helpers
extension WeatherNavigationController {
    private func configure() {
        isNavigationBarHidden = true
        
        isToolbarHidden = false
        
        toolbar.isTranslucent = true
        toolbar.setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
        toolbar.barTintColor = .clear
    }
}
