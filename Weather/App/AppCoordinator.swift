//
//  AppCoordinator.swift
//  Weather
//
//  Created by Andrei Kornilov on 04.10.2021.
//

import UIKit

final class AppCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController = UINavigationController()
    
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        navigationController = WeatherNavigationController(rootViewController: UIViewController())
        
        childCoordinators.removeAll()
        
        let weatherPagesCoordinator = WeatherPagesCoordinator(navigationController: navigationController)
        weatherPagesCoordinator.parentCoordinator = self
        childCoordinators.append(weatherPagesCoordinator)
        weatherPagesCoordinator.start()
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
