//
//  WeatherSearchCoordinator.swift
//  Weather
//
//  Created by Andrei Kornilov on 04.10.2021.
//

import UIKit

final class WeatherSearchCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    var secondaryNavigationController: UINavigationController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let weatherSearchViewController = WeatherSearchViewController()
        weatherSearchViewController.viewModel = WeatherSearchViewModel(navigation: self)
        
        let navigationController = UINavigationController(rootViewController: weatherSearchViewController)
        secondaryNavigationController = navigationController
        
        self.navigationController.presentedViewController?.present(navigationController, animated: true)
    }
}

// MARK: WeatherSearchViewModelNavigation
extension WeatherSearchCoordinator: WeatherSearchViewModelNavigation {
    func goToWeatherAdding(with location: Location) {
        let weatherAddingCoordinator = WeatherAddingCoordinator(navigationController: secondaryNavigationController ?? navigationController)
        weatherAddingCoordinator.parentCoordinator = self
        childCoordinators.append(weatherAddingCoordinator)
        
        weatherAddingCoordinator.start(with: location)
    }
}
