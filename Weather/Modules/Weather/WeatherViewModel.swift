//
//  WeatherViewModel.swift
//  Weather
//
//  Created by Andrei Kornilov on 04.10.2021.
//

import Foundation

protocol WeatherViewModelType {
    var weatherModel: Box<WeatherModel> { get }
    var weatherDailyForecastData: [WeatherDailyForecast] { get }

    init(weatherModel: WeatherModel)
    
    func dailyCellViewModel(at indexPath: IndexPath) -> DailyCellViewModelType
    func todayCellViewModel() -> TodayCellViewModelType
    func detailCellViewModel(at indexPath: IndexPath) -> DetailCellViewModelType
}

final class WeatherViewModel: WeatherViewModelType {
    // MARK: Private Properties
    private let disposeBag = DisposeBag()
    
    private(set) lazy var weatherDailyForecastData: [WeatherDailyForecast] = {
        var weatherDailyForecastData: [WeatherDailyForecast] = []
        let currentTimeInterval = weatherModel.value.data.current.dt
        
        weatherDailyForecastData = weatherModel.value.data.daily.filter { $0.dt > currentTimeInterval }
        
        return weatherDailyForecastData
    }()
    
    private lazy var dailyCellViewModels: [DailyCellViewModelType] = {
        var viewModels: [DailyCellViewModelType] = []

        for forecastData in weatherDailyForecastData {
            let item = DailyCellViewModel(
                time: forecastData.dt,
                icon: forecastData.weather.first?.icon,
                pop: forecastData.pop,
                temperatureMax: forecastData.temperature.max,
                temperatureMin: forecastData.temperature.min
            )

            viewModels.append(item)
        }

        return viewModels
    }()

    private lazy var detailCellViewModels: [DetailCellViewModelType] = {
        var viewModels: [DetailCellViewModelType] = []

        for detailData in WeatherModel.WeatherDetailType.allCases {
            viewModels.append(DetailCellViewModel(type: detailData, weatherModel: weatherModel.value))
        }

        return viewModels
    }()
    
    private(set) var weatherModel: Box<WeatherModel>

    // MARK: Initialization
    init(weatherModel: WeatherModel) {
        self.weatherModel = Box(weatherModel)

        bindWeatherModels()
    }
}

// MARK: Data Binding
extension WeatherViewModel {
    private func bindWeatherModels() {
        WeatherManager.shared.weatherModels
            .bind { [weak self] weatherModels in
                let weatherModel = self?.weatherModel.value
                
                if let weatherModel = weatherModels.filter({ $0.location == weatherModel?.location }).first {
                    self?.weatherModel.value = weatherModel
                }
            }
            .disposed(by: disposeBag)
    }
}

// MARK: Public Methods
extension WeatherViewModel {
    func dailyCellViewModel(at indexPath: IndexPath) -> DailyCellViewModelType {
        dailyCellViewModels[indexPath.row]
    }

    func todayCellViewModel() -> TodayCellViewModelType {
        TodayCellViewModel(weatherModel: weatherModel.value)
    }

    func detailCellViewModel(at indexPath: IndexPath) -> DetailCellViewModelType {
        detailCellViewModels[indexPath.row]
    }
}


