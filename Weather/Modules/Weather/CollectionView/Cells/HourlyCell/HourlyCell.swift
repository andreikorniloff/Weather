//
//  HourlyCell.swift
//  Weather
//
//  Created by Andrei Kornilov on 04.10.2021.
//

import UIKit

final class HourlyCell: UICollectionViewCell {
    static let reuseIdentifier = "HourlyCell"
    
    // MARK: Private Properties
    private let disposeBag = DisposeBag()
    
    // MARK: View Model
    var viewModel: HourlyCellViewModelType? {
        didSet {
            bindViewModel()
        }
    }
    
    // MARK: UI Components
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.white
        
        return label
    }()
    
    private lazy var popLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 11, weight: .semibold)
        label.textColor = Color.pop
        
        return label
    }()
    
    private lazy var weatherIcon: UIImageView = {
        let imageView = UIImageView()
    
        return imageView
    }()
    
    private lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.white
        
        return label
    }()
    
    // MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Data Binding
extension HourlyCell {
    private func bindViewModel() {
        guard let viewModel = viewModel else { return }
                
        timeLabel.text = viewModel.time
        popLabel.text = viewModel.pop
        
        if viewModel.isDescription {
            weatherIcon.image = UIImage(named: viewModel.temperature.value.lowercased())
        } else {
            weatherIcon.getImage(from: viewModel.icon)
        }
        
        viewModel.temperature
            .bind { [weak self] value in
                self?.temperatureLabel.text = value
            }
            .disposed(by: disposeBag)
    }
}

// MARK: Private Methods
extension HourlyCell {
    private func configure() {
        backgroundColor = .clear
        
        addSubview(timeLabel)
        addSubview(popLabel)
        addSubview(weatherIcon)
        addSubview(temperatureLabel)
        
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        timeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        popLabel.translatesAutoresizingMaskIntoConstraints = false
        popLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 1).isActive = true
        popLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        popLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        weatherIcon.translatesAutoresizingMaskIntoConstraints = false
        weatherIcon.widthAnchor.constraint(equalTo: weatherIcon.heightAnchor).isActive = true
        weatherIcon.widthAnchor.constraint(equalToConstant: 35).isActive = true
        weatherIcon.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        weatherIcon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        temperatureLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        temperatureLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
    }
}
