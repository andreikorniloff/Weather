//
//  WeatherPagesViewModel.swift
//  Weather
//
//  Created by Andrei Kornilov on 04.10.2021.
//

protocol WeatherPagesNavigation: Navigation {
    func goToWeatherList(delegate: WeatherListDelegate)
}

protocol WeatherPagesViewModelType {
    var pageViewModels: Box<[WeatherPageViewModel]> { get }
    
    func goToWeatherList(delegate: WeatherListDelegate)
}

final class WeatherPagesViewModel: WeatherPagesViewModelType {
    // MARK: Properties
    private let disposeBag = DisposeBag()
    private(set) var pageViewModels: Box<[WeatherPageViewModel]> = Box([])
    
    // MARK: Navigation
    private var navigation : WeatherPagesNavigation?
    
    // MARK: Initialization
    init(navigation: WeatherPagesNavigation) {
        self.navigation = navigation
        
        bindWeatherModels()
    }
}

// MARK: Data Binding
extension WeatherPagesViewModel {
    private func bindWeatherModels() {
        WeatherManager.shared.weatherModels
            .bind { [weak self] weatherModels in
                let pages = weatherModels.compactMap { WeatherPageViewModel(weatherModel: $0) }
            
                self?.pageViewModels.value = pages
            }
            .disposed(by: disposeBag)
    }
}

// MARK: Public Methods
extension WeatherPagesViewModel {
    func goToWeatherList(delegate: WeatherListDelegate) {
        navigation?.goToWeatherList(delegate: delegate)
    }
}
