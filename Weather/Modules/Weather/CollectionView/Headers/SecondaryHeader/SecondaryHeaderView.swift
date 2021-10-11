//
//  SecondaryHeaderView.swift
//  Weather
//
//  Created by Andrei Kornilov on 04.10.2021.
//

import UIKit

final class SecondaryHeaderView: UICollectionReusableView {
    static let reuseIdentifier = "SecondaryHeaderView"
    
    // MARK: Private Properties
    private let disposeBag = DisposeBag()
    
    // MARK: View Model
    var viewModel: SecondaryHeaderViewModelType? {
        didSet {
            configure()
            collectionView.reloadData()
            
            viewModel?.temperatureUnitChanged
                .bind { [weak self] _ in
                    self?.collectionView.reloadData()
                }
                .disposed(by: disposeBag)
        }
    }
    
    // MARK: Collection View
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 1, left: 12, bottom: 1, right: 12)
        
        let collectionView = UICollectionView(frame: bounds, collectionViewLayout: layout)
        collectionView.alwaysBounceHorizontal = true
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.register(HourlyCell.self, forCellWithReuseIdentifier: HourlyCell.reuseIdentifier)
        
        return collectionView
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
extension SecondaryHeaderView {
    private func configure() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.backgroundColor = .clear
        
        addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        collectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        addTopBorder(with: Color.weatherWhite, andHeight: 1 / UIScreen.main.scale)
        addBottomBorder(with: Color.weatherWhite, andHeight: 1 / UIScreen.main.scale)
    }
}

// MARK: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension SecondaryHeaderView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 0 }
        
        return viewModel.hourlyCellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: HourlyCell.reuseIdentifier,
            for: indexPath
        ) as? HourlyCell else { return UICollectionViewCell() }
        
        if let viewModel = viewModel {
            cell.viewModel = viewModel.hourlyCellViewModel(at: indexPath)
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var isDescription = false
        
        if let cellViewModel = viewModel?.hourlyCellViewModel(at: indexPath) {
            isDescription = cellViewModel.isDescription
        }
        
        let width: CGFloat = isDescription ? 55 : 40
        
        return CGSize(width: width, height: frame.height - 10)
    }
}
