//
//  WeatherPagesCoordinator.swift
//  Weather
//
//  Created by Andrei Kornilov on 04.10.2021.
//

import UIKit

final class WeatherPagesCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let weatherPagesViewController = WeatherPagesViewController()
        let weatherPagesViewModel = WeatherPagesViewModel(navigation: self)
        weatherPagesViewController.viewModel = weatherPagesViewModel
        
        navigationController.setViewControllers([weatherPagesViewController], animated: false)
    }
}

// MARK: WeatherPagesNavigation
extension WeatherPagesCoordinator: WeatherPagesNavigation {
    func goToWeatherList(delegate: WeatherListDelegate) {
        let weatherListCoordinator = WeatherListCoordinator(navigationController: navigationController)
        weatherListCoordinator.parentCoordinator = self
        weatherListCoordinator.delegate = delegate
        
        childCoordinators.append(weatherListCoordinator)
        weatherListCoordinator.start()
    }
}
