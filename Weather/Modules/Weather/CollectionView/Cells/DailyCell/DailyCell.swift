//
//  DailyCell.swift
//  Weather
//
//  Created by Andrei Kornilov on 04.10.2021.
//

import UIKit

final class DailyCell: WeatherCollectionViewCell {
    static let reuseIdentifier = "DailyCell"
    
    // MARK: Properties
    private let disposeBag = DisposeBag()
    
    // MARK: View Model
    var viewModel: DailyCellViewModelType? {
        didSet {
            bindViewModel()
        }
    }
    
    // MARK: UI Components
    private lazy var dayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.white
        label.numberOfLines = 0
        
        return label
    }()
 
    private lazy var weatherIcon: UIImageView = {
        let imageView = UIImageView()
    
        return imageView
    }()
    
    private lazy var popLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11, weight: .semibold)
        label.textColor = Color.pop
        
        return label
    }()
    
    private lazy var temperatureMaxLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.white
        
        return label
    }()
    
    private lazy var temperatureMinLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.white.withAlphaComponent(0.5)
        
        return label
    }()

    // MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Data Binding
extension DailyCell {
    private func bindViewModel() {
        guard let viewModel = viewModel else { return }
        
        dayLabel.text = viewModel.day
        popLabel.text = viewModel.pop
        weatherIcon.getImage(from: viewModel.icon)
        
        viewModel.temperatureMax
            .bind { [weak self] value in
                self?.temperatureMaxLabel.text = value
            }
            .disposed(by: disposeBag)
        
        viewModel.temperatureMin
            .bind { [weak self] value in
                self?.temperatureMinLabel.text = value
            }
            .disposed(by: disposeBag)
    }
}

// MARK: Private Methods
extension DailyCell {
    private func configureUI() {
        clipsToBounds = true
        
        backgroundColor = .clear

        addSubview(dayLabel)
        addSubview(weatherIcon)
        addSubview(popLabel)
        addSubview(temperatureMaxLabel)
        addSubview(temperatureMinLabel)
        
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        dayLabel.clipsToBounds = true
        dayLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        dayLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5).isActive = true
        dayLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 130).isActive = true
        
        weatherIcon.translatesAutoresizingMaskIntoConstraints = false
        weatherIcon.widthAnchor.constraint(equalTo: weatherIcon.heightAnchor).isActive = true
        weatherIcon.widthAnchor.constraint(equalToConstant: 35).isActive = true
        weatherIcon.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        weatherIcon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        popLabel.translatesAutoresizingMaskIntoConstraints = false
        popLabel.centerYAnchor.constraint(equalTo: weatherIcon.centerYAnchor).isActive = true
        popLabel.leadingAnchor.constraint(equalTo: weatherIcon.trailingAnchor, constant: 5).isActive = true
        popLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        temperatureMaxLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatureMaxLabel.centerYAnchor.constraint(equalTo: weatherIcon.centerYAnchor).isActive = true
        temperatureMaxLabel.trailingAnchor.constraint(equalTo: temperatureMinLabel.leadingAnchor, constant: -15).isActive = true
        temperatureMaxLabel.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
        temperatureMinLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatureMinLabel.centerYAnchor.constraint(equalTo: weatherIcon.centerYAnchor).isActive = true
        temperatureMinLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        temperatureMinLabel.widthAnchor.constraint(equalToConstant: 24).isActive = true
    }
}
