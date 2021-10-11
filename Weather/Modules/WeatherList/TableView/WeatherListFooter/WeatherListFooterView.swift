//
//  WeatherListFooterView.swift
//  Weather
//
//  Created by Andrei Kornilov on 04.10.2021.
//

import UIKit

final class WeatherListFooterView: UITableViewHeaderFooterView {
    static let reuseIdentifier = "WeatherListFooterView"
    
    // MARK: Private Properties
    private let disposeBag = DisposeBag()
    
    // MARK: View Model
    var viewModel: WeatherListFooterViewModelType? {
        didSet {
            configureUI()
            
            viewModel?.temperatureUnit
                .bind { [weak self] value in
                    self?.configureUnitButtons()
                }
                .disposed(by: disposeBag)
        }
    }

    // MARK: UI Components
    private lazy var slashLabel: UILabel = {
        let label = UILabel()
        
        label.text = "/"
        label.textColor = .lightGray
        
        return label
    }()
    
    private lazy var celsiusButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("°C", for: .normal)
        button.setTitleColor(.white, for: .selected)
        button.setTitleColor(.lightGray, for: .normal)
        button.addTarget(self, action: #selector(celsiusButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var fahrenheitButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("°F", for: .normal)
        button.setTitleColor(.white, for: .selected)
        button.setTitleColor(.lightGray, for: .normal)
        button.addTarget(self, action: #selector(fahrenheitButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var githubButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.setImage(UIImage(named: "githubIcon"), for: .normal)
        button.tintColor = .gray
        button.addTarget(self, action: #selector(githubButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var searchButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var celsiusFahrenheitStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        
        stackView.addArrangedSubview(celsiusButton)
        stackView.addArrangedSubview(slashLabel)
        stackView.addArrangedSubview(fahrenheitButton)

        return stackView
    }()
}

// MARK: Private Methods
extension WeatherListFooterView {
    private func configureUI() {
        contentView.backgroundColor = .black
        
        contentView.addSubview(celsiusFahrenheitStackView)
        contentView.addSubview(githubButton)
        contentView.addSubview(searchButton)
        
        githubButton.translatesAutoresizingMaskIntoConstraints = false
        githubButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        githubButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        celsiusFahrenheitStackView.translatesAutoresizingMaskIntoConstraints = false
        celsiusFahrenheitStackView.topAnchor.constraint(equalTo: githubButton.topAnchor).isActive = true
        celsiusFahrenheitStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        celsiusFahrenheitStackView.bottomAnchor.constraint(equalTo: githubButton.bottomAnchor).isActive = true
        
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        searchButton.topAnchor.constraint(equalTo: githubButton.topAnchor).isActive = true
        searchButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        searchButton.bottomAnchor.constraint(equalTo: githubButton.bottomAnchor).isActive = true
    }
    
    private func configureUnitButtons() {
        guard let temperatureUnit = viewModel?.temperatureUnit.value else { return }
        
        celsiusButton.isSelected = temperatureUnit == .celsius
        fahrenheitButton.isSelected = temperatureUnit == .fahrenheit
    }
}

// MARK: Button Actions
extension WeatherListFooterView {
    @objc
    private func celsiusButtonTapped() {
        viewModel?.setTemperatureUnit(with: .celsius)
    }
    
    @objc
    private func fahrenheitButtonTapped() {
        viewModel?.setTemperatureUnit(with: .fahrenheit)
    }
    
    @objc
    private func githubButtonTapped() {
        if let url = URL(string: Constant.githubURL) {
            UIApplication.shared.open(url)
        }
    }
    
    @objc
    private func searchButtonTapped() {
        viewModel?.delegate?.goToSearch()
    }
}

