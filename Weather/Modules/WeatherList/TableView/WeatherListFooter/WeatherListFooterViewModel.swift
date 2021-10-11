//
//  WeatherListFooterViewModel.swift
//  Weather
//
//  Created by Andrei Kornilov on 04.10.2021.
//

protocol WeatherListFooterViewDelegate {
    func goToSearch()
}

protocol WeatherListFooterViewModelType {
    var delegate: WeatherListFooterViewDelegate? { get }
    var temperatureUnit: Box<TemperatureUnit> { get }
    
    func setTemperatureUnit(with value: TemperatureUnit)
}

final class WeatherListFooterViewModel: WeatherListFooterViewModelType {
    // MARK: Properties
    var delegate: WeatherListFooterViewDelegate?
    var temperatureUnit: Box<TemperatureUnit>
    
    // MARK: Initialization
    init() {
        temperatureUnit = Box(PreferenceManager.shared.temperatureUnit.value)
    }
}

// MARK: Public Methods
extension WeatherListFooterViewModel {
    func setTemperatureUnit(with value: TemperatureUnit) {
        temperatureUnit.value = value
        PreferenceManager.shared.setTemperatureUnit(with: temperatureUnit.value)
    }
}
