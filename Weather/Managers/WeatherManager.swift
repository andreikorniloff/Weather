//
//  WeatherManager.swift
//  Weather
//
//  Created by Andrei Kornilov on 03.10.2021.
//

import Foundation
import UIKit

final class WeatherManager {
    static let shared = WeatherManager()
    
    // MARK: Properties For Subscription
    private(set) var weatherModels: Box<[WeatherModel]> = Box([])
    
    // MARK: Initialization
    private init() {}
}

// MARK: Fetch Methods
extension WeatherManager {
    func fetchWeather(at location: Location, completion: @escaping ((WeatherModel) -> Void)) {
        OpenWeatherMapService.shared.fetchData(for: location) { weatherData in
            let weatherModel = WeatherModel(location: location, data: weatherData)
            completion(weatherModel)
        }
    }
    
    func fetchAllWeather(with locations: [Location]) {
        var weatherModels = [WeatherModel]()
        let locations = StorageManager.shared.fetchLocations()

        let dispatchGroup = DispatchGroup()
        
        for location in locations {
            dispatchGroup.enter()
            
            OpenWeatherMapService.shared.fetchData(for: location) { weatherData in
                let weatherModel = WeatherModel(location: location, data: weatherData)
                weatherModels.append(weatherModel)
                
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            let sortedWeatherModels: [WeatherModel] = locations.enumerated().compactMap { (index, location) in
                let weatherModel = weatherModels.filter({ $0.location == location }).first
                return weatherModel
            }
            
            self?.weatherModels.value = sortedWeatherModels
        }
    }
}

// MARK: Data Operation Methods
extension WeatherManager {
    func addWeatherModel(_ weatherModel: WeatherModel) {
        let location = weatherModel.location
        StorageManager.shared.saveLocation(location)
        
        weatherModels.value.append(weatherModel)
    }

    func removeWeatherModel(at index: Int) {
        guard index < weatherModels.value.count else { return }
        
        let location = weatherModels.value[index].location
        StorageManager.shared.removeLocation(location)
        
        weatherModels.value.remove(at: index)
    }
}
