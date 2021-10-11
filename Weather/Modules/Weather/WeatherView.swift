//
//  WeatherView.swift
//  Weather
//
//  Created by Andrei Kornilov on 04.10.2021.
//

import UIKit

final class WeatherView: UIView {
    // MARK: Type Aliases
    typealias DataSource = UICollectionViewDiffableDataSource<WeatherSectionType, AnyHashable>
    typealias Snapshot = NSDiffableDataSourceSnapshot<WeatherSectionType, AnyHashable>
    
    // MARK: Private Properties
    private let disposeBag = DisposeBag()
    private var snapshot: Snapshot! = nil

    // MARK: View Model
    var viewModel: WeatherViewModelType? {
        didSet {
            viewModel?.weatherModel
                .bind { [weak self] _ in
                    self?.reloadData()
                }
                .disposed(by: disposeBag)
        }
    }

    // MARK: CollectionView
    private lazy var collectionView: UICollectionView = {
        let collectionView = createCollectionView()
        return collectionView
    }()

    // MARK: DataSource
    private lazy var dataSource: DataSource = {
        let dataSource = createDataSource()
        return dataSource
    }()
}

// MARK: Private Methods
extension WeatherView {
    private func reloadData() {
        snapshot = Snapshot()
        snapshot.appendSections([.current, .daily, .today, .detail])

        if let weatherDaily = viewModel?.weatherDailyForecastData {
            snapshot.appendItems(weatherDaily, toSection: .daily)
        }
        
        snapshot.appendItems(["X"], toSection: .today)
        snapshot.appendItems(WeatherModel.WeatherDetailType.allCases, toSection: .detail)

        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: CollectionView Methods
extension WeatherView {
    private func createCollectionView() -> UICollectionView {
        let collectionView = UICollectionView(
            frame: bounds,
            collectionViewLayout: createCompositionalLayout()
        )

        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.alwaysBounceVertical = true

        // MARK: Headers
        collectionView.register(
            PrimaryHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: PrimaryHeaderView.reuseIdentifier
        )

        collectionView.register(
            SecondaryHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SecondaryHeaderView.reuseIdentifier
        )

        // MARK: Cells
        collectionView.register(DailyCell.self, forCellWithReuseIdentifier: DailyCell.reuseIdentifier)
        collectionView.register(TodayCell.self, forCellWithReuseIdentifier: TodayCell.reuseIdentifier)
        collectionView.register(DetailCell.self, forCellWithReuseIdentifier: DetailCell.reuseIdentifier)

        addSubview(collectionView)

        collectionView.edgeTo(view: self)

        return collectionView
    }

    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let layout = WeatherCollectionViewCompositionalLayout { [weak self] (sectionIndex, layoutEnviroment) -> NSCollectionLayoutSection? in
            let type = self?.snapshot.sectionIdentifiers[sectionIndex]

            switch type {
            case .current:
                return self?.createCurrentSection()
            case .daily:
                return self?.createDailySection()
            case .today:
                return self?.createTodaySection()
            case .detail:
                return self?.createDetailSection()
            case .none:
                return nil
            }
        }

        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 1

        layout.configuration = config

        return layout
    }

    private func createCurrentSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(150))

        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(Constant.defaultHeightForTopHeader))
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )

        let section = NSCollectionLayoutSection(group: group)

        section.contentInsets = NSDirectionalEdgeInsets.init(top: 10, leading: 0, bottom: 0, trailing: 0)
        section.boundarySupplementaryItems = [header]

        return section
    }

    private func createDailySection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(30))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(100))
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )

        let section = NSCollectionLayoutSection(group: group)

        section.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 0, bottom: 0, trailing: 0)
        section.boundarySupplementaryItems = [header]

        return section
    }

    private func createTodaySection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 0, bottom: 0, trailing: 0)

        return section
    }

    private func createDetailSection() -> NSCollectionLayoutSection {
        let fraction: CGFloat = 1 / 2
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(fraction), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(45))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 5
        section.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 16, bottom: 0, trailing: 16)

        return section
    }
}

// MARK: CollectionViewDiffableDataSource
extension WeatherView {
    private func createDataSource() -> DataSource {
        let dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { [weak self] (collectionView, indexPath, value) -> UICollectionViewCell? in
                guard let section = WeatherSectionType(rawValue: indexPath.section) else {
                    fatalError("Unknown section type")
                }

                switch section {
                case .daily:
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: DailyCell.reuseIdentifier,
                        for: indexPath
                    ) as? DailyCell else {
                        fatalError("Unable to dequeue forecast data cell")
                    }

                    if let viewModel = self?.viewModel {
                        cell.viewModel = viewModel.dailyCellViewModel(at: indexPath)
                    }

                    return cell
                case .today:
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: TodayCell.reuseIdentifier,
                        for: indexPath
                    ) as? TodayCell else {
                        fatalError("Unable to dequeue today data cell")
                    }

                    if let viewModel = self?.viewModel {
                        cell.viewModel = viewModel.todayCellViewModel()
                    }

                    return cell
                case .detail:
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: DetailCell.reuseIdentifier,
                        for: indexPath
                    ) as? DetailCell else {
                        fatalError("Unable to dequeue details data cell")
                    }

                    if let viewModel = self?.viewModel {
                        var viewModel = viewModel.detailCellViewModel(at: indexPath)
                        viewModel.indexPath = indexPath
                        
                        cell.viewModel = viewModel
                        cell.configureUI()
                    }

                    return cell
                default:
                    return nil
                }
            }
        )

        dataSource.supplementaryViewProvider = { [weak self]
            (collectionView: UICollectionView,
             kind: String,
             indexPath: IndexPath) -> UICollectionReusableView? in
            guard let section = WeatherSectionType(rawValue: indexPath.section) else {
                fatalError("Unknown section type for supplementary")
            }

            switch section {
            case .current:
                guard let kind = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: PrimaryHeaderView.reuseIdentifier,
                    for: indexPath
                ) as? PrimaryHeaderView else {
                    fatalError("Cannot create new supplementary for current data section")
                }

                if let weatherModel = self?.viewModel?.weatherModel.value {
                    kind.viewModel = PrimaryHeaderViewModel(weatherModel: weatherModel)
                }

                return kind
            case .daily:
                guard let kind = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: SecondaryHeaderView.reuseIdentifier,
                    for: indexPath
                ) as? SecondaryHeaderView else {
                    fatalError("Cannot create new supplementary for forecast data section")
                }

                if let weatherModel = self?.viewModel?.weatherModel.value {
                    kind.viewModel = SecondaryHeaderViewModel(weatherModel: weatherModel)
                }

                return kind
            default:
                return nil
            }
        }

        return dataSource
    }
}
