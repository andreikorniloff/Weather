//
//  WeatherListViewModel.swift
//  Weather
//
//  Created by Andrei Kornilov on 04.10.2021.
//

import UIKit

protocol WeatherListViewModelNavigation: Navigation {
    func goToSearch(from vc: UIViewController)
    func goToSelectedWeatherPage(at index: Int)
}

protocol WeatherListViewModelType {
    var weatherModels: Box<[WeatherModel]> { get set }

    init(navigation: WeatherListViewModelNavigation)
    
    func cellViewModel(at indexPath: IndexPath) -> WeatherListCellViewModelType
    func removeWeatherModel(at index: Int)
    
    func goToSearch(from vc: UIViewController)
    func goToSelectedWeatherPage(at index: Int)
    func didFinish()
}

final class WeatherListViewModel: WeatherListViewModelType {
    // MARK: Properties
    private let disposeBag = DisposeBag()
    var weatherModels: Box<[WeatherModel]> = Box([])
    
    // MARK: Navigation
    private var navigation: WeatherListViewModelNavigation?

    // MARK: Initialization
    init(navigation: WeatherListViewModelNavigation) {
        self.navigation = navigation
        
        bindWeatherModels()
    }
}

// MARK: Data Binding
extension WeatherListViewModel {
    private func bindWeatherModels() {
        WeatherManager.shared.weatherModels
            .bind { [weak self] weatherModels in
                self?.weatherModels.value = weatherModels
            }
            .disposed(by: disposeBag)
    }
}

// MARK: Public Methods
extension WeatherListViewModel {
    func cellViewModel(at indexPath: IndexPath) -> WeatherListCellViewModelType {
        let weatherModel = weatherModels.value[indexPath.row]
        
        let itemViewModel = WeatherListCellViewModel(
            weatherModel: weatherModel,
            time: weatherModel.data.current.dt,
            location: weatherModel.location.displayName,
            temperature: weatherModel.data.current.temperature
        )
        
        return itemViewModel
    }
    
    func removeWeatherModel(at index: Int) {
        WeatherManager.shared.removeWeatherModel(at: index)
    }
    
    func goToSelectedWeatherPage(at index: Int) {
        navigation?.goToSelectedWeatherPage(at: index)
    }
    
    func goToSearch(from vc: UIViewController) {
        navigation?.goToSearch(from: vc)
    }
    
    func didFinish() {
        navigation?.didFinish()
    }
}
