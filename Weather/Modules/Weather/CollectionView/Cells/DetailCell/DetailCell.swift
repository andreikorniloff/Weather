//
//  DetailCell.swift
//  Weather
//
//  Created by Andrei Kornilov on 04.10.2021.
//

import UIKit

final class DetailCell: WeatherCollectionViewCell {
    static let reuseIdentifier = "DetailCell"
    
    // MARK: Private Properties
    private let disposeBag = DisposeBag()
    
    // MARK: View Model
    var viewModel: DetailCellViewModelType? {
        didSet {
            titleLabel.text = viewModel?.title
            viewModel?.value
                .bind { [weak self] value in
                    self?.valueLabel.text = value
                }
                .disposed(by: disposeBag)
        }
    }
    
    // MARK: UI Components
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.white.withAlphaComponent(0.5)
        
        return label
    }()
    
    private lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = UIColor.white
        
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.spacing = 1
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(valueLabel)
        
        return stackView
    }()
    
    private lazy var topSeparator: UIView = {
        let view = UIView()
        
        view.backgroundColor = Color.weatherWhite
        
        return view
    }()
    
    // MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private Methods
extension DetailCell {
    func configureUI() {
        backgroundColor = .clear
        
        addSubview(topSeparator)
        addSubview(stackView)
        
        topSeparator.translatesAutoresizingMaskIntoConstraints = false
        topSeparator.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        topSeparator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        topSeparator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        topSeparator.heightAnchor.constraint(equalToConstant: 0.5 / UIScreen.main.scale).isActive = true
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: topSeparator.topAnchor, constant: 5).isActive = true
        stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        if let indexPath = viewModel?.indexPath {
            topSeparator.isHidden = indexPath.row <= 1
        }
    }
}
