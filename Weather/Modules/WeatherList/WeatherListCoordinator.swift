//
//  WeatherListCoordinator.swift
//  Weather
//
//  Created by Andrei Kornilov on 04.10.2021.
//

import UIKit

protocol WeatherListDelegate: AnyObject {
    func didSelectWeatherPage(at index: Int)
}

final class WeatherListCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    var delegate: WeatherListDelegate?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let weatherListViewController = WeatherListViewController()
        weatherListViewController.modalPresentationStyle = .fullScreen
        
        let weatherLisViewModel = WeatherListViewModel(navigation: self)
        weatherListViewController.viewModel = weatherLisViewModel
        
        navigationController.present(weatherListViewController, animated: true)
    }
}

// MARK: WeatherListViewModelNavigation
extension WeatherListCoordinator: WeatherListViewModelNavigation {
    func goToSearch(from vc: UIViewController) {
        let weatherSearchCoordinator = WeatherSearchCoordinator(navigationController: navigationController)
        weatherSearchCoordinator.parentCoordinator = self
        childCoordinators.append(weatherSearchCoordinator)
        
        weatherSearchCoordinator.start()
    }
    
    func goToSelectedWeatherPage(at index: Int) {
        delegate?.didSelectWeatherPage(at: index)
        navigationController.dismiss(animated: true)
    }
}
