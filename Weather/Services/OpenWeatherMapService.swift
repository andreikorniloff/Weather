//
//  OpenWeatherMapService.swift
//  Weather
//
//  Created by Andrei Kornilov on 03.10.2021.
//

import Foundation

final class OpenWeatherMapService {
    static let shared = OpenWeatherMapService()

    private let apiKey = "" // PUT YOUR API KEY HERE
    
    private init() {}
}

// MARK: Networking
extension OpenWeatherMapService {
    func fetchImage(for imageName: String?, completion: @escaping (Data) -> Void) {
        guard let url = weatherImageURL(for: imageName) else {
            print("URL creation error")
            return
        }
        
        if let cachedData = getDataFromCache(for: url) {
            completion(cachedData)
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data,
                  let response = response else {
                print(error?.localizedDescription ?? "No Discription")
                return
            }

            guard url == response.url else {
                print("Response URL error")
                return
            }
            self?.saveDataToCache(with: data, response: response)
            completion(data)
        }.resume()
    }
    
    func fetchData(for location: Location, completion: @escaping (_ weatherData: WeatherResponse) -> Void) {
        do {
            var cachedDataResponse: WeatherResponse?
            let url = try weatherOneCallURL(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            
            if let cachedData = getDataFromCache(for: url) {
                do {
                    cachedDataResponse = try JSONDecoder().decode(WeatherResponse.self, from: cachedData)
                    guard let cachedDataResponse = cachedDataResponse else { return }
                    
                    let now = Date().timeIntervalSince1970
                    if now > cachedDataResponse.current.dt, now - cachedDataResponse.current.dt < Constant.cacheLifeTimeInSeconds {
                        DispatchQueue.main.async {
                            completion(cachedDataResponse)
                        }
                        return
                    }
                } catch let error {
                    print("Error serialization json", error)
                    return
                }
            }
            
            URLSession.shared.dataTask(with: url) { [weak self] data , response, error in
                guard let data = data, let response = response, error == nil else {
                    print(error?.localizedDescription ?? "No Discription")
                    
                    if let cachedDataResponse = cachedDataResponse {
                        DispatchQueue.main.async {
                            completion(cachedDataResponse)
                        }
                    }
                    
                    return
                }

                do {
                    let dataResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
                    self?.saveDataToCache(with: data, response: response)
                    DispatchQueue.main.async {
                        completion(dataResponse)
                    }
                } catch let error {
                    print("Error serialization json", error)
                }
            }.resume()
        } catch let error {
            print("Error fetch data", error)
        }
    }
}

// MARK: Cache Support
extension OpenWeatherMapService {
    private func getDataFromCache(for url: URL) -> Data? {
        var cachedData: Data? = nil
        
        let request = URLRequest(url: url)
        
        if let cachedResponse = URLCache.shared.cachedResponse(for: request) {
            cachedData = cachedResponse.data
        }
        
        return cachedData
    }
    
    private func saveDataToCache(with data: Data, response: URLResponse) {
        guard let url = response.url else { return }
        
        let request = URLRequest(url: url)
        
        let cachedResponse = CachedURLResponse(response: response, data: data)
        
        URLCache.shared.storeCachedResponse(cachedResponse, for: request)
    }
}

// MARK: Helpers
extension OpenWeatherMapService {
    private func weatherOneCallURL(latitude: Double, longitude: Double, excludes: [WeatherDataType] = [.minutely, .alerts]) throws -> URL {
        let temperatureUnit: String = TemperatureUnit.celsius.rawValue
        
        let endpoint = Endpoint.oneCall(
            apiKey: apiKey,
            latitude: latitude,
            longitude: longitude,
            temperatureUnit: temperatureUnit,
            excludes: excludes
        )
    
        guard let url = URL(string: endpoint.url) else {
            fatalError("Error build url")
        }
        
        return url
    }
    
    private func weatherImageURL(for imageName: String?) -> URL? {
        guard let imageName = imageName,
              let url = URL(string: Endpoint.image(named: imageName).url)
        else { return nil }
        
        return url
    }
}
