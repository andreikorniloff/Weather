//
//  HourlyCellViewModel.swift
//  Weather
//
//  Created by Andrei Kornilov on 04.10.2021.
//

import Foundation

protocol HourlyCellViewModelType: AnyObject {
    var timeRaw: TimeInterval { get }
    var isNow: Bool { get }
    var isDescription: Bool { get }
    
    var time: String { get }
    var pop: String { get }
    var icon: String? { get }
    var temperature: Box<String> { get }
    
    init(time: TimeInterval, pop: Float, icon: String?, temperature: Float, isNow: Bool, timezoneOffset: TimeInterval)
    init(time: TimeInterval, icon: String?, description: String, timezoneOffset: TimeInterval)
}

final class HourlyCellViewModel: HourlyCellViewModelType {
    // MARK: Properties
    private let disposeBag = DisposeBag()
    
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        
        return dateFormatter
    }()
    
    private var temperatureCelsius: Float?
    
    private(set) var timeRaw: TimeInterval
    private(set) var isNow: Bool
    private(set) var isDescription: Bool
 
    private(set) var time: String
    private(set) var pop: String
    private(set) var icon: String?
    private(set) var temperature: Box<String> = Box("-")
    
    // MARK: Initialization
    init(time: TimeInterval, pop: Float, icon: String? = nil, temperature: Float, isNow: Bool = false, timezoneOffset: TimeInterval) {
        dateFormatter.timeZone = TimeZone(secondsFromGMT: Int(timezoneOffset))
        dateFormatter.setLocalizedDateFormatFromTemplate("HH")
        
        self.timeRaw = time
        self.isNow = isNow
        self.isDescription = false
        
        self.time = isNow ? "Now" : dateFormatter.string(from: Date(timeIntervalSince1970: timeRaw))
        self.pop = pop >= 0.3 ? "\(Int(pop * 100)) %" : ""
        self.icon = icon
        
        temperatureCelsius = temperature

        let temperatureValue = TemperatureUnit.temperatureUnitValue(for: temperature)
        self.temperature.value = "\(Int(roundf(temperatureValue)))°"
    }
    
    init(time: TimeInterval, icon: String?, description: String, timezoneOffset: TimeInterval) {
        dateFormatter.timeZone = TimeZone(secondsFromGMT: Int(timezoneOffset))
        dateFormatter.setLocalizedDateFormatFromTemplate("HHmm")
        
        self.timeRaw = time
        self.isNow = false
        self.isDescription = true
        
        self.time = dateFormatter.string(from: Date(timeIntervalSince1970: timeRaw))
        self.pop = ""
        self.icon = icon
        self.temperature.value = description.capitalized
    }
}

// MARK: Data Binding
extension HourlyCellViewModel {
    private func bindTemperatureUnit() {
        PreferenceManager.shared.temperatureUnit
            .bind { [weak self] unit in
                guard let temperatureCelsius = self?.temperatureCelsius else { return }
                
                let temperatureValue = TemperatureUnit.temperatureUnitValue(for: temperatureCelsius)
                self?.temperature.value = "\(Int(roundf(temperatureValue)))°"
            }
            .disposed(by: disposeBag)
    }
}
