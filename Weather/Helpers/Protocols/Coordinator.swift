//
//  Coordinator.swift
//  Weather
//
//  Created by Andrei Kornilov on 03.10.2021.
//

import UIKit

protocol Coordinator: AnyObject, Navigation {
    var parentCoordinator: Coordinator? { get set }
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }

    func start()
}

extension Coordinator {
    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
    
    func didFinish() {
        parentCoordinator?.childDidFinish(self)
    }
}
