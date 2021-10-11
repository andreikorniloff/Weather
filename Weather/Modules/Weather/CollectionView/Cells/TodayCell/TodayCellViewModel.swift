//
//  TodayCellViewModel.swift
//  Weather
//
//  Created by Andrei Kornilov on 04.10.2021.
//

import Foundation

protocol TodayCellViewModelType {
    var text: Box<String> { get }
    
    init(weatherModel: WeatherModel)
}

final class TodayCellViewModel: TodayCellViewModelType {
    // MARK: Properties
    private let disposeBag = DisposeBag()

    private let weatherModel: WeatherModel
    private(set) var text: Box<String> = Box("--")
    
    // MARK: Initialization
    init(weatherModel: WeatherModel) {
        self.weatherModel = weatherModel

        bindTemperatureUnit()
    }
}

// MARK: Data Binding
extension TodayCellViewModel {
    private func bindTemperatureUnit() {
        PreferenceManager.shared.temperatureUnit
            .bind { [weak self] unit in
                guard let weatherModel = self?.weatherModel,
                      let textValue = self?.descriptionText(with: weatherModel, and: unit)
                else { return }

                self?.text.value = textValue
            }
            .disposed(by: disposeBag)
    }
}

// MARK: Private Methods
extension TodayCellViewModel {
    private func descriptionText(with weatherModel: WeatherModel, and unit: TemperatureUnit = .celsius) -> String {
        var textValue = ""
        
        if let description = weatherModel.data.current.weather.first?.description {
            textValue += "Today: \(description.capitalized). "
        }

        let temperature = weatherModel.data.current.temperature
        let temperatureValue = TemperatureUnit.temperatureUnitValue(for: temperature)
        textValue += "It's current \(Int(roundf(temperatureValue)))°. "
        
        if let maxTemperature = weatherModel.data.daily.first?.temperature.max {
            let maxTemperatureValue = TemperatureUnit.temperatureUnitValue(for: maxTemperature)
            textValue += "The high will be \(Int(roundf(maxTemperatureValue)))°. "
        }
        
        return textValue
    }
}
