//
//  WeatherAddingViewModel.swift
//  Weather
//
//  Created by Andrei Kornilov on 04.10.2021.
//

protocol WeatherAddingViewModelNavigation: Navigation {
    func onDismiss(withParent: Bool)
}

protocol WeatherAddingViewModelType {
    init(navigation: WeatherAddingViewModelNavigation, location: Location)
    
    func weatherViewModel(completion: @escaping ((WeatherViewModelType) -> Void))
    
    func isAddingAllowed() -> Bool
    func addWeather()
    
    func onDismiss()
    func didFinish()
}

final class WeatherAddingViewModel: WeatherAddingViewModelType {
    // MARK: Navigation
    private var navigation: WeatherAddingViewModelNavigation?
    
    // MARK: Private Properties
    private var location: Location
    private var weatherModel: WeatherModel?

    // MARK: Initialization
    init(navigation: WeatherAddingViewModelNavigation, location: Location) {
        self.navigation = navigation
        self.location = location
    }
}

// MARK: Public Methods
extension WeatherAddingViewModel {
    func weatherViewModel(completion: @escaping ((WeatherViewModelType) -> Void)) {
        WeatherManager.shared.fetchWeather(at: location) { [weak self] weatherModel in
            self?.weatherModel = weatherModel
            
            let weatherViewModel = WeatherViewModel(weatherModel: weatherModel)
            completion(weatherViewModel)
        }
    }
    
    func isAddingAllowed() -> Bool {
        let locations = WeatherManager.shared.weatherModels.value.map { $0.location }
        
        return !locations.contains(
            where: { l in l.coordinate.latitude == self.location.coordinate.latitude &&
                          l.coordinate.longitude == self.location.coordinate.longitude })
    }
    
    func addWeather() {
        if let weatherModel = weatherModel {
            WeatherManager.shared.addWeatherModel(weatherModel)
        }
        
        navigation?.onDismiss(withParent: true)
    }
    
    func onDismiss() {
        navigation?.onDismiss(withParent: false)
    }
    
    func didFinish() {
        navigation?.didFinish()
    }
}
