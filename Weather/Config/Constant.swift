//
//  Constant.swift
//  Weather
//
//  Created by Andrei Kornilov on 27.09.2021.
//

import UIKit

struct Constant {
    
    // MARK: Network
    static let cacheLifeTimeInSeconds: Double = 900
    static let oneCallURL = "https://api.openweathermap.org/data/2.5/onecall"
    static let imageURL = "https://openweathermap.org/img/wn/"
    
    static let githubURL: String = "https://github.com/andreikorniloff"
    
    static let defaultHeightForTopHeader = 0.38 * UIScreen.main.bounds.height
    static let minHeightForTopHeader: CGFloat = 80
    static let topConstraintMultiplier: CGFloat = 0.08
    
    static let heightForRowWeatherList: CGFloat = 76
    static let heightForClipViewWeatherListCell: CGFloat = 63
    static let heightForFooterWeatherList: CGFloat = 44
}
