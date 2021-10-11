//
//  WeatherPageViewModel.swift
//  Weather
//
//  Created by Andrei Kornilov on 04.10.2021.
//

protocol WeatherPageViewModelType {
    var weatherModel: WeatherModel { get }
    
    init(weatherModel: WeatherModel)
}

final class WeatherPageViewModel: WeatherPageViewModelType {
    // MARK: Properties
    private(set) var weatherModel: WeatherModel
    
    // MARK: Initialization
    init(weatherModel: WeatherModel) {
        self.weatherModel = weatherModel
    }
}
