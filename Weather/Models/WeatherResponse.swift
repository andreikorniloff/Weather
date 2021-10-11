//
//  WeatherResponse.swift
//  Weather
//
//  Created by Andrei Kornilov on 03.10.2021.
//

import Foundation

// MARK: WeatherResponse
struct WeatherResponse: Decodable, Hashable {
    let id = UUID()
    let latitude: Double
    let longitude: Double
    let timezone: String
    let timezoneOffset: TimeInterval
    let current: WeatherCurrent
    let hourly: [WeatherHourlyForecast]
    let daily: [WeatherDailyForecast]
    
    enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lon"
        case timezone
        case timezoneOffset = "timezone_offset"
        case current
        case hourly
        case daily
    }
    
    func hash(into hasher: inout Hasher) {
      hasher.combine(id)
    }
    
    static func == (lhs: WeatherResponse, rhs: WeatherResponse) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: WeatherCurrent
struct WeatherCurrent: Decodable {
    let dt: TimeInterval
    let sunrise: TimeInterval
    let sunset: TimeInterval
    let temperature: Float
    let feelsLike: Float
    let pressure: Int
    let humidity: Int
    let dewPoint: Float
    let uvi: Float
    let clouds: Int
    let visibility: Int
    let windSpeed: Float
    let windGust: Float?
    let windDegree: Int
    let rain: Rain?
    let snow: Snow?
    let weather: [Weather]
    
    enum CodingKeys: String, CodingKey {
        case dt
        case sunrise
        case sunset
        case temperature = "temp"
        case feelsLike = "feels_like"
        case pressure
        case humidity
        case dewPoint = "dew_point"
        case uvi
        case clouds
        case visibility
        case windSpeed = "wind_speed"
        case windGust = "wind_gust"
        case windDegree = "wind_deg"
        case rain
        case snow
        case weather
    }
}

// MARK: WeatherHourlyForecast
struct WeatherHourlyForecast: Decodable {
    let dt: TimeInterval
    let temperature: Float
    let feelsLike: Float
    let pressure: Int
    let humidity: Int
    let dewPoint: Float
    let uvi: Float
    let clouds: Int
    let visibility: Int
    let windSpeed: Float
    let windGust: Float?
    let windDegree: Int
    let pop: Float
    let rain: Rain?
    let snow: Snow?
    let weather: [Weather]
    
    enum CodingKeys: String, CodingKey {
        case dt
        case temperature = "temp"
        case feelsLike = "feels_like"
        case pressure
        case humidity
        case dewPoint = "dew_point"
        case uvi
        case clouds
        case visibility
        case windSpeed = "wind_speed"
        case windGust = "wind_gust"
        case windDegree = "wind_deg"
        case pop
        case rain
        case snow
        case weather
    }
}

// MARK: WeatherDailyForecast
struct WeatherDailyForecast: Decodable, Hashable {
    let dt: TimeInterval
    let sunrise: TimeInterval
    let sunset: TimeInterval
    let moonrise: TimeInterval
    let moonset: TimeInterval
    let temperature: ForecastTemperature
    let feelsLike: ForecastFeelsLike
    let pressure: Int
    let humidity: Int
    let dewPoint: Float
    let uvi: Float
    let clouds: Int
    let windSpeed: Float
    let windGust: Float?
    let windDegree: Int
    let pop: Float
    let rain: Float?
    let snow: Float?
    let weather: [Weather]
    
    enum CodingKeys: String, CodingKey {
        case dt
        case sunrise
        case sunset
        case moonrise
        case moonset
        case temperature = "temp"
        case feelsLike = "feels_like"
        case pressure
        case humidity
        case dewPoint = "dew_point"
        case uvi
        case clouds
        case windSpeed = "wind_speed"
        case windGust = "wind_gust"
        case windDegree = "wind_deg"
        case pop
        case rain
        case snow
        case weather
    }
    
    func hash(into hasher: inout Hasher) {
      hasher.combine(dt)
    }
    
    static func == (lhs: WeatherDailyForecast, rhs: WeatherDailyForecast) -> Bool {
        lhs.dt == rhs.dt
    }
}

// MARK: Rain
struct Rain: Decodable {
    let last1h: Float?
    
    enum CodingKeys: String, CodingKey {
        case last1h = "1h"
    }
}

// MARK: Snow
struct Snow: Decodable {
    let last1h: Float?
    
    enum CodingKeys: String, CodingKey {
        case last1h = "1h"
    }
}

// MARK: Weather
struct Weather: Decodable {
    let id: Int
    let main: String
    let description: String
    let icon: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case main
        case description
        case icon
    }
}

// MARK: ForecastTemperature
struct ForecastTemperature: Decodable {
    let morning: Float
    let day: Float
    let evening: Float
    let night: Float
    let min: Float
    let max: Float
    
    enum CodingKeys: String, CodingKey {
        case morning = "morn"
        case day
        case evening = "eve"
        case night
        case min
        case max
    }
}

// MARK: ForecastFeelsLike
struct ForecastFeelsLike: Decodable {
    let morning: Float
    let day: Float
    let evening: Float
    let night: Float
    
    enum CodingKeys: String, CodingKey {
        case morning = "morn"
        case day
        case evening = "eve"
        case night
    }
}
