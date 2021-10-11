//
//  WeatherListCellViewModel.swift
//  Weather
//
//  Created by Andrei Kornilov on 04.10.2021.
//

import Foundation
import UIKit

protocol WeatherListCellViewModelType {
    var weatherColor: UIColor { get }
    var time: String { get }
    var location: String { get }
    var temperature: Box<String> { get }

    init(weatherModel: WeatherModel, time: TimeInterval, location: String, temperature: Float)
}

final class WeatherListCellViewModel: WeatherListCellViewModelType {
    // MARK: Private Properties
    private let disposeBag = DisposeBag()
    
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        
        dateFormatter.locale = Locale.current
        dateFormatter.setLocalizedDateFormatFromTemplate("HHmm")
        
        return dateFormatter
    }()
    
    private var temperatureCelsius: Float
    
    // MARK: Public Properties
    private(set) var weatherColor: UIColor
    private(set) var time: String
    private(set) var location: String
    private(set) var temperature: Box<String> = Box("--")
    
    // MARK: Initialization
    init(weatherModel: WeatherModel, time: TimeInterval, location: String, temperature: Float) {
        self.temperatureCelsius = temperature
        
        self.weatherColor = UIColor.color(for: weatherModel.data.current)
        self.location = location

        dateFormatter.timeZone = TimeZone(secondsFromGMT: Int(weatherModel.data.timezoneOffset))
        self.time = dateFormatter.string(from: Date())
        
        bindTemperatureUnit()
    }
}

// MARK: Data Binding
extension WeatherListCellViewModel {
    func bindTemperatureUnit() {
        PreferenceManager.shared.temperatureUnit
            .bind { [weak self] unit in
                guard let temperatureCelsius = self?.temperatureCelsius else { return }
            
                let temperatureValue = TemperatureUnit.temperatureUnitValue(for: temperatureCelsius)
                self?.temperature.value = "\(Int(roundf(temperatureValue)))°"
            }
            .disposed(by: disposeBag)
    }
}
