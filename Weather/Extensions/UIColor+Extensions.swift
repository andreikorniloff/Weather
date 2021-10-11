//
//  UIColor+Extensions.swift
//  Weather
//
//  Created by Andrei Kornilov on 04.10.2021.
//

import UIKit

extension UIColor {
    class func color(for weatherCurrent: WeatherCurrent?) -> UIColor {
        guard let weatherCurrent = weatherCurrent,
              let weatherId = weatherCurrent.weather.first?.id
        else { return .secondarySystemBackground }
        
        let isNight = weatherCurrent.dt > weatherCurrent.sunset

        switch weatherId {
        case 200..<300:
            return isNight ? Color.thunderstornNight : Color.thunderstorn
        case 300..<400:
            return isNight ? Color.drizzleNight : Color.drizzle
        case 500..<600:
            return isNight ? Color.rainNight : Color.rain
        case 600..<700:
            return isNight ? Color.snowNight : Color.snow
        case 700..<800:
            return isNight ? Color.atmosphereNight : Color.atmosphere
        case 800:
            return isNight ? Color.clearNight : Color.clear
        case 801..<900:
            return isNight ? Color.cloudsNight : Color.clouds
        default:
            return .secondarySystemBackground
        }
    }
}
