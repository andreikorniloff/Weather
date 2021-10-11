//
//  DailyCellViewModel.swift
//  Weather
//
//  Created by Andrei Kornilov on 04.10.2021.
//

import Foundation

protocol DailyCellViewModelType {
    var day: String { get }
    var icon: String? { get }
    var pop: String { get }
    var temperatureMax: Box<String> { get }
    var temperatureMin: Box<String> { get }
    
    init(time: TimeInterval, icon: String?, pop: Float, temperatureMax: Float, temperatureMin: Float)
}

final class DailyCellViewModel: DailyCellViewModelType {
    // MARK: Properties
    private let disposeBag = DisposeBag()
    
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.setLocalizedDateFormatFromTemplate("EEEE")
        
        return dateFormatter
    }()
    
    private(set) var timeRaw: TimeInterval
    
    private(set) var day: String
    private(set) var icon: String?
    private(set) var pop: String
    private(set) var temperatureMax: Box<String> = Box("")
    private(set) var temperatureMin: Box<String> = Box("")
    
    private var temperatureMaxCelsius: Float
    private var temperatureMinCelsius: Float
    
    // MARK: Initialization
    init(time: TimeInterval, icon: String? = nil, pop: Float, temperatureMax: Float, temperatureMin: Float) {
        self.timeRaw = time
        self.day = dateFormatter.string(from: Date(timeIntervalSince1970: time))
        self.icon = icon
        self.pop = pop >= 0.3 ? "\(Int(pop * 100)) %" : ""
        
        self.temperatureMaxCelsius = temperatureMax
        self.temperatureMinCelsius = temperatureMin

        bindTemperatureUnit()
    }
}

// MARK: Data Binding
extension DailyCellViewModel {
    private func bindTemperatureUnit() {
        PreferenceManager.shared.temperatureUnit
            .bind { [weak self] unit in
                guard let temperatureMaxCelsius = self?.temperatureMaxCelsius,
                      let temperatureMinCelsius = self?.temperatureMinCelsius
                else { return }
                
                let temperatureMaxValue = TemperatureUnit.temperatureUnitValue(for: temperatureMaxCelsius)
                self?.temperatureMax.value = "\(Int(roundf(temperatureMaxValue)))"
                
                let temperatureMinValue = TemperatureUnit.temperatureUnitValue(for: temperatureMinCelsius)
                self?.temperatureMin.value = "\(Int(roundf(temperatureMinValue)))"
            }
            .disposed(by: disposeBag)
    }
}
