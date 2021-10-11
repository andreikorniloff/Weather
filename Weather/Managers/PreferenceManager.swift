//
//  PreferenceManager.swift
//  Weather
//
//  Created by Andrei Kornilov on 03.10.2021.
//

import Foundation

final class PreferenceManager {
    static let shared = PreferenceManager()
    
    private let userDefaults = UserDefaults()
    private let temperatureUnitKey = "ru.andreikorniloff.weather.temperatureunit"
    
    private(set) lazy var temperatureUnit: Box<TemperatureUnit> = {
        guard let value = userDefaults.string(forKey: temperatureUnitKey),
              let temperatureUnit = TemperatureUnit(rawValue: value)
        else {
            return Box(.celsius)
        }
        
        return Box(temperatureUnit)
    }()
    
    private init() {}
    
    func setTemperatureUnit(with value: TemperatureUnit) {
        temperatureUnit.value = value
        userDefaults.set(temperatureUnit.value.rawValue, forKey: temperatureUnitKey)
    }
}
