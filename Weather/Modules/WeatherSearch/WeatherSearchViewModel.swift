//
//  WeatherSearchViewModel.swift
//  Weather
//
//  Created by Andrei Kornilov on 04.10.2021.
//

protocol WeatherSearchViewModelNavigation: Navigation {
    func goToWeatherAdding(with location: Location)
}

protocol WeatherSearchViewModelType {
    init(navigation: WeatherSearchViewModelNavigation)
    
    func goToWeatherAdding(with location: Location)
    func didFinish()
}

final class WeatherSearchViewModel: WeatherSearchViewModelType {
    // MARK: Navigation
    private var navigation: WeatherSearchViewModelNavigation?
    
    // MARK: Initialization
    init(navigation: WeatherSearchViewModelNavigation) {
        self.navigation = navigation
    }
}

// MARK: Public Methods
extension WeatherSearchViewModel {
    func goToWeatherAdding(with location: Location) {
        navigation?.goToWeatherAdding(with: location)
    }
    
    func didFinish() {
        navigation?.didFinish()
    }
}
