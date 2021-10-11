//
//  SecondaryHeaderViewModel.swift
//  Weather
//
//  Created by Andrei Kornilov on 04.10.2021.
//

import Foundation

protocol SecondaryHeaderViewModelType {
    var weatherModel: WeatherModel { get }
    var hourlyCellViewModels: [HourlyCellViewModelType] { get }
    var temperatureUnitChanged: Box<Bool> { get }
    
    init(weatherModel: WeatherModel)
    
    func hourlyCellViewModel(at indexPath: IndexPath) -> HourlyCellViewModelType
}

final class SecondaryHeaderViewModel: SecondaryHeaderViewModelType {
    // MARK: Properties
    private let disposeBag = DisposeBag()
    
    private(set) var weatherModel: WeatherModel
    
    var hourlyCellViewModels: [HourlyCellViewModelType] {
        var hourlyCellViewModels: [HourlyCellViewModelType] = []
        
        var sunriseTime: TimeInterval {
            if Date().timeIntervalSince1970 > weatherModel.data.current.sunrise {
                if weatherModel.data.daily.count > 2 {
                   return weatherModel.data.daily[1].sunrise
                }
            }
            
            return weatherModel.data.current.sunrise
        }
        
        var sunsetTime: TimeInterval {
            if Date().timeIntervalSince1970 > weatherModel.data.current.sunset {
                if weatherModel.data.daily.count > 2 {
                   return weatherModel.data.daily[1].sunset
                }
            }
            
            return weatherModel.data.current.sunset
        }
        
        let nowItem = HourlyCellViewModel(
            time: Date().timeIntervalSince1970,
            pop: 0,
            icon: weatherModel.data.current.weather.first?.icon,
            temperature: weatherModel.data.current.temperature,
            isNow: true,
            timezoneOffset: weatherModel.data.timezoneOffset
        )
        
        hourlyCellViewModels.append(nowItem)
        
        for hourlyData in weatherModel.data.hourly[0..<24] {
            if let lastItem = hourlyCellViewModels.last,
               lastItem.timeRaw < hourlyData.dt,
               lastItem.timeRaw...hourlyData.dt ~= sunriseTime {
                
                let sunriseItem = HourlyCellViewModel(
                    time: sunriseTime,
                    icon: nil,
                    description: "sunrise",
                    timezoneOffset: weatherModel.data.timezoneOffset
                )
                
                hourlyCellViewModels.append(sunriseItem)
            }
            
            if let lastItem = hourlyCellViewModels.last,
               lastItem.timeRaw < hourlyData.dt,
               lastItem.timeRaw...hourlyData.dt ~= sunsetTime {
                let sunsetItem = HourlyCellViewModel(
                    time: sunsetTime,
                    icon: nil,
                    description: "sunset",
                    timezoneOffset: weatherModel.data.timezoneOffset
                )
                
                hourlyCellViewModels.append(sunsetItem)
            }
            
            let item = HourlyCellViewModel(
                time: hourlyData.dt,
                pop: hourlyData.pop,
                icon: hourlyData.weather.first?.icon,
                temperature: hourlyData.temperature,
                timezoneOffset: weatherModel.data.timezoneOffset
            )
            
            hourlyCellViewModels.append(item)
        }
        
        return hourlyCellViewModels
    }
    
    private(set) var temperatureUnitChanged: Box<Bool> = Box(false)
    
    // MARK: Initialization
    init(weatherModel: WeatherModel) {
        self.weatherModel = weatherModel
        
        bindTemperatureUnit()
    }
}

// MARK: Data Binding
extension SecondaryHeaderViewModel {
    func bindTemperatureUnit() {
        PreferenceManager.shared.temperatureUnit
            .bind { [weak self] _ in
                self?.temperatureUnitChanged.value = true
            }
            .disposed(by: disposeBag)
    }
}

// MARK: Public Methods
extension SecondaryHeaderViewModel {
    func hourlyCellViewModel(at indexPath: IndexPath) -> HourlyCellViewModelType {
        hourlyCellViewModels[indexPath.row]
    }
    
    func createLocalUrl(forImageNamed name: String, imageExtension: String = "svg") -> URL? {
        let fileManager = FileManager.default

        guard let cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            print("Unable to access cache directory")
            return nil
        }

        let url = cacheDirectory.appendingPathComponent("\(name).\(imageExtension)")

        return url
    }
}
