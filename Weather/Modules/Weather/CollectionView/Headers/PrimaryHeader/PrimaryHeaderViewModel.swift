//
//  PrimaryHeaderViewModel.swift
//  Weather
//
//  Created by Andrei Kornilov on 04.10.2021.
//

import Foundation

protocol PrimaryHeaderViewModelType {
    var cityName: String { get }
    var weatherDescription: String { get }
    var temperature: Box<String> { get }
    var temperatureMax: Box<String> { get }
    var temperatureMin: Box<String> { get }
    
    init(weatherModel: WeatherModel)
}

final class PrimaryHeaderViewModel: PrimaryHeaderViewModelType {
    // MARK: Properties
    private let disposeBag = DisposeBag()
    private let weatherModel: WeatherModel
    
    private(set) var cityName: String
    private(set) var weatherDescription: String
    private(set) var temperature: Box<String> = Box("--°")
    private(set) var temperatureMax: Box<String> = Box("--°")
    private(set) var temperatureMin: Box<String> = Box("--°")
    
    private var temperatureCelsius: Float
    private var temperatureMaxCelsius: Float?
    private var temperatureMinCelsius: Float?
    
    // MARK: Initialization
    init(weatherModel: WeatherModel) {
        self.weatherModel = weatherModel
        
        cityName = weatherModel.location.displayName
        weatherDescription = weatherModel.data.current.weather.first?.main ?? "--"
        temperatureCelsius = weatherModel.data.current.temperature
        temperatureMaxCelsius = weatherModel.data.daily.first?.temperature.max
        temperatureMinCelsius = weatherModel.data.daily.first?.temperature.min

        bindTemperatureUnit()
    }
}

extension PrimaryHeaderViewModel {
    private func bindTemperatureUnit() {
        PreferenceManager.shared.temperatureUnit
            .bind { [weak self] unit in
                guard let temperatureCelsius = self?.temperatureCelsius else { return }
            
                let temperatureValue = TemperatureUnit.temperatureUnitValue(for: temperatureCelsius)
                self?.temperature.value = "\(Int(roundf(temperatureValue)))"
                
                if let temperatureMaxCelsius = self?.temperatureMaxCelsius {
                    let temperatureValue = TemperatureUnit.temperatureUnitValue(for: temperatureMaxCelsius)
                    self?.temperatureMax.value = "H:\(Int(roundf(temperatureValue)))°"
                }
                
                if let temperatureMinCelsius = self?.temperatureMinCelsius {
                    let temperatureValue = TemperatureUnit.temperatureUnitValue(for: temperatureMinCelsius)
                    self?.temperatureMin.value = "L:\(Int(roundf(temperatureValue)))°"
                }
            }
            .disposed(by: disposeBag)
    }
}
