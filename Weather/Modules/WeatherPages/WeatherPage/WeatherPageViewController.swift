//
//  WeatherPageViewController.swift
//  Weather
//
//  Created by Andrei Kornilov on 04.10.2021.
//

import UIKit

final class WeatherPageViewController: UIViewController {
    // MARK: View Model
    var viewModel: WeatherPageViewModelType? {
        didSet {
            if let weatherModel = viewModel?.weatherModel {
                let viewModel = WeatherViewModel(weatherModel: weatherModel)
                weatherView.viewModel = viewModel
            }
        }
    }
    
    // MARK: UI Components
    private lazy var weatherView: WeatherView = {
        let view = WeatherView()

        return view
    }()
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
}

// MARK: Private Methods
extension WeatherPageViewController {
    private func configureUI() {
        view.backgroundColor = Color.clear
        
        if let weatherCurrentData = viewModel?.weatherModel.data.current {
            view.backgroundColor = UIColor.color(for: weatherCurrentData)
        }
        
        view.addSubview(weatherView)
        weatherView.edgeTo(layoutGuide: view.safeAreaLayoutGuide)
    }
}
