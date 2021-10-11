//
//  WeatherAddingViewController.swift
//  Weather
//
//  Created by Andrei Kornilov on 04.10.2021.
//

import UIKit

final class WeatherAddingViewController: UIViewController {
    // MARK: View Model
    var viewModel: WeatherAddingViewModelType? {
        didSet {
            viewModel?.weatherViewModel { [weak self] weatherViewModel in
                self?.weatherView.viewModel = weatherViewModel
                
                let weatherDataCurrent = weatherViewModel.weatherModel.value.data.current
                DispatchQueue.main.async {
                    self?.view.backgroundColor = UIColor.color(for: weatherDataCurrent)
                }
            }
            
            if let isAddingAllowed = viewModel?.isAddingAllowed(), isAddingAllowed {
                navigationItem.rightBarButtonItem  = addBarButtonItem
            }
        }
    }
    
    // MARK: UI Components
    private lazy var weatherView: WeatherView = {
        let view = WeatherView()
        view.backgroundColor = .clear
        
        return view
    }()
    
    private lazy var cancelBarButtonItem: UIBarButtonItem = {
        let item = UIBarButtonItem(
            image: nil,
            style: .plain,
            target: self,
            action: #selector(cancelBarButtonItemTapped)
        )
        
        item.tintColor = .white
        item.title = "Cancel"
        return item
    }()
    
    private lazy var addBarButtonItem: UIBarButtonItem = {
        let item = UIBarButtonItem(
            image: nil,
            style: .done,
            target: self,
            action: #selector(addBarButtonItemTapped)
        )
        item.tintColor = .white
        item.title = "Add"
        return item
    }()
    
    // MARK: Lyfe Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureWeatherView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        viewModel?.didFinish()
    }
}

// MARK: Private Methods
extension WeatherAddingViewController {
    private func configureUI() {
        view.backgroundColor = Color.clear
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.layoutIfNeeded()
        navigationItem.leftBarButtonItem  = cancelBarButtonItem
    }

    private func configureWeatherView() {
        view.addSubview(weatherView)
        weatherView.edgeTo(layoutGuide: view.safeAreaLayoutGuide)
    }
}

// MARK: Button Actions
extension WeatherAddingViewController {
    @objc private func cancelBarButtonItemTapped() {
        viewModel?.onDismiss()
    }
    
    @objc private func addBarButtonItemTapped() {
        viewModel?.addWeather()
    }
}
