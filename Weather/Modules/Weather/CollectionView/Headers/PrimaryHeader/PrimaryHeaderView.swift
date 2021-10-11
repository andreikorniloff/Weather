//
//  PrimaryHeaderView.swift
//  Weather
//
//  Created by Andrei Kornilov on 04.10.2021.
//

import UIKit

final class PrimaryHeaderView: UICollectionReusableView {
    static let reuseIdentifier = "PrimaryHeaderView"
    
    // MARK: Private Properties
    private let disposeBag = DisposeBag()
    private var topConstraint: NSLayoutConstraint? = nil
    
    // MARK: View Model
    var viewModel: PrimaryHeaderViewModelType? {
        didSet {
            bindViewModel()
        }
    }
    
    // MARK: UI Components
    private lazy var cityNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 34)
        label.textColor = UIColor.white
        
        return label
    }()
    
    private lazy var weatherDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.white
        
        return label
    }()
    
    private lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 88, weight: UIFont.Weight.thin)
        label.textColor = UIColor.white
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var temperatureUnitLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 88, weight: UIFont.Weight.thin)
        label.textColor = UIColor.white
        label.text = "°"
        
        return label
    }()
    
    private lazy var temperatureMaxLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = UIColor.white
        
        return label
    }()
    
    private lazy var temperatureMinLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = UIColor.white
        
        return label
    }()
    
    private lazy var cityDescriptionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = NSLayoutConstraint.Axis.vertical
        stackView.distribution = UIStackView.Distribution.equalSpacing
        stackView.alignment = UIStackView.Alignment.center
        stackView.spacing = 1.0
        
        stackView.addArrangedSubview(cityNameLabel)
        stackView.addArrangedSubview(weatherDescriptionLabel)
        
        return stackView
    }()
    
    private lazy var temperatureMaxMinStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 10.0
        
        stackView.addArrangedSubview(temperatureMaxLabel)
        stackView.addArrangedSubview(temperatureMinLabel)
        
        return stackView
    }()
    
    // MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout Subviews
    override func layoutSubviews() {
        super.layoutSubviews()
        
        topConstraint?.constant = frame.height * Constant.topConstraintMultiplier

        let alpha = calculateAlpha()
        
        temperatureLabel.alpha = alpha
        temperatureUnitLabel.alpha = alpha
        temperatureMaxMinStackView.alpha = alpha
    }
}

// MARK: Data Binding
extension PrimaryHeaderView {
    private func bindViewModel() {
        cityNameLabel.text = viewModel?.cityName
        weatherDescriptionLabel.text = viewModel?.weatherDescription
        
        viewModel?.temperature
            .bind { [weak self] value in
                self?.temperatureLabel.text = value
            }
            .disposed(by: disposeBag)
        
        viewModel?.temperatureMax
            .bind { [weak self] value in
                self?.temperatureMaxLabel.text = value
            }
            .disposed(by: disposeBag)
        
        viewModel?.temperatureMin
            .bind { [weak self] value in
                self?.temperatureMinLabel.text = value
            }
            .disposed(by: disposeBag)
    }
}

// MARK: Private Methods
extension PrimaryHeaderView {
    private func configureUI() {
        addSubview(cityDescriptionStackView)
        addSubview(temperatureLabel)
        addSubview(temperatureUnitLabel)
        addSubview(temperatureMaxMinStackView)
        
        cityDescriptionStackView.translatesAutoresizingMaskIntoConstraints = false
        cityDescriptionStackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        cityDescriptionStackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        topConstraint = cityDescriptionStackView.topAnchor.constraint(equalTo: topAnchor, constant: frame.height * Constant.topConstraintMultiplier)
        topConstraint?.isActive = true

        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.topAnchor.constraint(equalTo: cityDescriptionStackView.bottomAnchor).isActive = true
        temperatureLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        temperatureUnitLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatureUnitLabel.topAnchor.constraint(equalTo: temperatureLabel.topAnchor).isActive = true
        temperatureUnitLabel.leadingAnchor.constraint(equalTo: temperatureLabel.trailingAnchor).isActive = true
        
        temperatureMaxMinStackView.translatesAutoresizingMaskIntoConstraints = false
        temperatureMaxMinStackView.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor).isActive = true
        temperatureMaxMinStackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    private func calculateAlpha() -> CGFloat {
        let transparentY = temperatureLabel.frame.height + temperatureLabel.frame.origin.y
        
        return max((frame.height - transparentY) / (Constant.defaultHeightForTopHeader - transparentY), 0)
    }
}
