//
//  WeatherAddingCoordinator.swift
//  Weather
//
//  Created by Andrei Kornilov on 04.10.2021.
//

import UIKit

final class WeatherAddingCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
    }
    
    func start(with location: Location) {
        let weatherAddingViewController = WeatherAddingViewController()
        weatherAddingViewController.viewModel = WeatherAddingViewModel(navigation: self, location: location)
        
        let navigationController = UINavigationController(rootViewController: weatherAddingViewController)
        self.navigationController.present(navigationController, animated: true)
    }
}

// MARK: WeatherAddingViewModelNavigation
extension WeatherAddingCoordinator: WeatherAddingViewModelNavigation {
    func onDismiss(withParent: Bool) {
        if withParent {
            parentCoordinator?.navigationController.presentedViewController?.dismiss(animated: true)
        } else {
            navigationController.dismiss(animated: true)
        }
    }
}
