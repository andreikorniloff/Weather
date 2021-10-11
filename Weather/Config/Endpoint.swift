//
//  Endpoint.swift
//  Weather
//
//  Created by Andrei Kornilov on 06.10.2021.
//

enum Endpoint {
    case oneCall(
            apiKey: String,
            latitude: Double,
            longitude: Double,
            temperatureUnit: String,
            excludes: [WeatherDataType] = [.minutely, .alerts]
         )
    
    case image(named: String)
}

extension Endpoint {
    var url: String {
        switch self {
        case let .oneCall(apiKey, latitude, longitude, temperatureUnit, excludes):
            let excludes = excludes.map { $0.rawValue }.joined(separator: ",")
            
            let url = Constant.oneCallURL +
                "?lat=\(latitude)&lon=\(longitude)&units=\(temperatureUnit)&exclude=\(excludes)&appid=\(apiKey)"
            
            return url
        case let .image(imageName):
            return "\(Constant.imageURL)\(imageName)@2x.png"
        }
    }
}


