//
//  WeatherListCell.swift
//  Weather
//
//  Created by Andrei Kornilov on 04.10.2021.
//

import UIKit

final class WeatherListCell: UITableViewCell {
    static let reuseIdentifier = "WeatherListCell"
    
    // MARK: Private Properties
    private let disposeBag = DisposeBag()
    
    // MARK: View Model
    var viewModel: WeatherListCellViewModelType? {
        didSet {
            timeLabel.text = viewModel?.time
            locationLabel.text = viewModel?.location
            
            viewModel?.temperature
                .bind { [weak self] temperature in
                    self?.temperatureLabel.text = temperature
                }
                .disposed(by: disposeBag)
            
            configureUI()
        }
    }
    
    // MARK: Public Properties
    var heightForClipView = Constant.heightForClipViewWeatherListCell
    
    // MARK: UI Components
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 14)
        label.textColor = .white
        label.numberOfLines = 0
        
        return label
    }()
    
    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 24)
        label.textColor = .white
        label.numberOfLines = 0
        
        return label
    }()
    
    private lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 52, weight: UIFont.Weight.thin)
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .right
        
        return label
    }()
    
    private lazy var timeLocationStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading
        
        stackView.addArrangedSubview(timeLabel)
        stackView.addArrangedSubview(locationLabel)
        
        return stackView
    }()
    
    lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 1.0
        
        stackView.addArrangedSubview(timeLocationStackView)
        stackView.addArrangedSubview(temperatureLabel)
        
        return stackView
    }()
    
    lazy var clipView: UIView = {
        let view = UIView()
        
        view.backgroundColor = .clear
        view.clipsToBounds = true
        
        view.addSubview(mainStackView)
        
        return view
    }()
}

// MARK: Private Methods
extension WeatherListCell {
    private func configureUI() {
        backgroundColor = viewModel?.weatherColor
        
        addSubview(clipView)
        
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.leadingAnchor.constraint(equalTo: clipView.leadingAnchor).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: clipView.trailingAnchor).isActive = true
        mainStackView.bottomAnchor.constraint(equalTo: clipView.bottomAnchor).isActive = true
        
        clipView.translatesAutoresizingMaskIntoConstraints = false
        clipView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        clipView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        clipView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6).isActive = true
        clipView.heightAnchor.constraint(equalToConstant: heightForClipView).isActive = true
    }
}
