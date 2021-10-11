//
//  TodayCell.swift
//  Weather
//
//  Created by Andrei Kornilov on 04.10.2021.
//

import UIKit

final class TodayCell: WeatherCollectionViewCell {
    static let reuseIdentifier = "TodayCell"
    
    // MARK: Private Properties
    private let disposeBag = DisposeBag()
    
    // MARK: View Model
    var viewModel: TodayCellViewModelType? {
        didSet {
            viewModel?.text
                .bind { [weak self] value in
                    self?.textLabel.text = value
                }
                .disposed(by: disposeBag)
        }
    }
    
    // MARK: UI Components
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.white
        label.numberOfLines = 2
        
        return label
    }()
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.contentInsetAdjustmentBehavior = .automatic
        textView.textColor = UIColor.white
        
        return textView
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

// MARK: Private Methods
extension TodayCell {
    private func configureUI() {
        backgroundColor = .clear
        
        addSubview(textLabel)

        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        textLabel.widthAnchor.constraint(lessThanOrEqualToConstant: UIScreen.main.bounds.width - 32).isActive = true
        
        contentView.addTopBorder(with: Color.weatherWhite, andHeight: 1 / UIScreen.main.scale)
        contentView.addBottomBorder(with: Color.weatherWhite, andHeight: 1 / UIScreen.main.scale)
    }
}
