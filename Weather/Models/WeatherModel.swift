//
//  WeatherModel.swift
//  Weather
//
//  Created by Andrei Kornilov on 03.10.2021.
//

// MARK: Type Aliases
typealias TemperatureUnit = WeatherModel.TemperatureUnit
typealias WeatherDataType = WeatherModel.WeatherDataType
typealias WeatherSectionType = WeatherModel.WeatherSectionType
typealias WeatherDetailType = WeatherModel.WeatherDetailType

struct WeatherModel: Equatable {
    let location: Location
    let data: WeatherResponse
    
    enum TemperatureUnit: String {
        case celsius = "metric"
        case fahrenheit = "imperial"
    }
    
    enum WeatherDataType: String {
        case current
        case minutely
        case hourly
        case daily
        case alerts
    }

    enum WeatherSectionType: Int, Hashable {
        case current
        case daily
        case today
        case detail
    }
    
    enum WeatherDetailType: CaseIterable {
        case sunrise
        case sunset
        case chanceOfRain
        case humidity
        case wind
        case feelsLike
        case precipitation
        case pressure
        case visibility
        case uvi
    }
}

// MARK: Extensions
extension WeatherModel.TemperatureUnit {
    static func temperatureUnitValue(for celsius: Float) -> Float {
        let temperatureUnit = PreferenceManager.shared.temperatureUnit.value
        
        switch temperatureUnit {
        case .celsius:
            return celsius
        case .fahrenheit:
            return celsius * 9 / 5 + 32
        }
    }
}

extension WeatherModel {
    static func getWindDirection(from degree: Int) -> String {
        switch degree {
        case 348...360, 0...11:
            return "N"
        case 12...33:
            return "NNE"
        case 34...56:
            return "NE"
        case 57...78:
            return "ENE"
        case 79...101:
            return "E"
        case 102...123:
            return "ESE"
        case 124...146:
            return "SE"
        case 147...168:
            return "SSE"
        case 169...191:
            return "S"
        case 192...213:
            return "SSW"
        case 214...236:
            return "SW"
        case 237...258:
            return "WSW"
        case 259...281:
            return "W"
        case 282...303:
            return "WNW"
        case 304...326:
            return "NW"
        case 327...348:
            return "NNW"
        default:
            return ""
        }
    }
}

