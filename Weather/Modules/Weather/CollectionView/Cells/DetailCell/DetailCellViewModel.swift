//
//  DetailCellViewModel.swift
//  Weather
//
//  Created by Andrei Kornilov on 04.10.2021.
//

import Foundation

protocol DetailCellViewModelType {
    var title: String { get }
    var value: Box<String> { get }
    var indexPath: IndexPath? { get set }
    
    init(type: WeatherModel.WeatherDetailType, weatherModel: WeatherModel)
}

final class DetailCellViewModel: DetailCellViewModelType {
    // MARK: Properties
    private let disposeBag = DisposeBag()
    
    private let type: WeatherModel.WeatherDetailType
    private let weatherModel: WeatherModel
    
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        
        return dateFormatter
    }()
    
    private(set) var title: String
    private(set) var value: Box<String> = Box("")
    var indexPath: IndexPath?
    
    private var feelsLikeCelsius: Float?
    
    // MARK: Initialization
    init(type: WeatherModel.WeatherDetailType, weatherModel: WeatherModel) {
        dateFormatter.timeZone = TimeZone(secondsFromGMT: Int(weatherModel.data.timezoneOffset))
        
        self.type = type
        self.weatherModel = weatherModel
        self.indexPath = IndexPath()
        
        switch type {
        case .sunrise:
            dateFormatter.setLocalizedDateFormatFromTemplate("HHmm")
            
            var sunriseTime: TimeInterval {
                if Date().timeIntervalSince1970 > weatherModel.data.current.sunrise {
                    if weatherModel.data.daily.count > 2 {
                       return weatherModel.data.daily[1].sunrise
                    }
                }
                
                return weatherModel.data.current.sunrise
            }
            
            title = "sunrise".uppercased()
            value.value = dateFormatter.string(from: Date(timeIntervalSince1970: sunriseTime))
        case .sunset:
            dateFormatter.setLocalizedDateFormatFromTemplate("HHmm")
            
            var sunsetTime: TimeInterval {
                if Date().timeIntervalSince1970 > weatherModel.data.current.sunset {
                    if weatherModel.data.daily.count > 2 {
                       return weatherModel.data.daily[1].sunset
                    }
                }
                
                return weatherModel.data.current.sunset
            }
            
            title = "sunset".uppercased()
            value.value = dateFormatter.string(from: Date(timeIntervalSince1970: sunsetTime))
        case .chanceOfRain:
            var chanceOfRain: Float {
                guard let chanceOfRain = weatherModel.data.daily.first?.pop else { return 0 }
                
                return chanceOfRain
            }
            
            title = "chance of rain".uppercased()
            value.value = "\(Int(chanceOfRain * 100)) %"
        case .humidity:
            title = "humidity".uppercased()
            value.value = "\(Int(weatherModel.data.current.humidity)) %"
        case .wind:
            title = "wind".uppercased()
            value.value = "\(WeatherModel.getWindDirection(from: weatherModel.data.current.windDegree)) \(Int(weatherModel.data.current.windSpeed)) m/s"
        case .feelsLike:
            feelsLikeCelsius = weatherModel.data.current.feelsLike
            let feelsLikeValue = TemperatureUnit.temperatureUnitValue(for: weatherModel.data.current.feelsLike)
            
            title = "feels like".uppercased()
            value.value = "\(Int(roundf(feelsLikeValue)))°"
        case .precipitation:
            var rain: Float {
                guard let rain = weatherModel.data.current.rain?.last1h else { return 0 }
                
                return rain
            }
            
            title = "precipitation".uppercased()
            value.value = "\(Int(rain)) cm"
        case .pressure:
            title = "pressure".uppercased()
            value.value = "\(weatherModel.data.current.pressure) hPa"
        case .visibility:
            title = "visibility".uppercased()
            value.value = "\(Int(weatherModel.data.current.visibility / 1000)) km"
        case .uvi:
            title = "uv index".uppercased()
            value.value = "\(Int(weatherModel.data.current.uvi))"
        }
        
        bindTemperatureUnit()
    }
}

// MARK: Data Binding
extension DetailCellViewModel {
    private func bindTemperatureUnit() {
        PreferenceManager.shared.temperatureUnit
            .bind { [weak self] unit in
                guard let type = self?.type,
                      let feelsLikeCelsius = self?.feelsLikeCelsius
                else { return }
            
                if type == .feelsLike {
                    let feelsLikeValue = TemperatureUnit.temperatureUnitValue(for: feelsLikeCelsius)
                    self?.value.value = "\(Int(roundf(feelsLikeValue)))°"
                }
            }
            .disposed(by: disposeBag)
    }
}
