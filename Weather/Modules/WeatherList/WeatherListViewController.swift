//
//  WeatherListViewController.swift
//  Weather
//
//  Created by Andrei Kornilov on 04.10.2021.
//

import UIKit



final class WeatherListViewController: UITableViewController {
    // MARK: Private Properties
    private let disposeBag = DisposeBag()
    private var weatherModels: [WeatherModel] = []
    
    // MARK: View Model
    var viewModel: WeatherListViewModelType? {
        didSet {
            viewModel?.weatherModels
                .bind { [weak self] weatherModels in
                    self?.weatherModels = weatherModels
                
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                }
                .disposed(by: disposeBag)
        }
    }

    // MARK: Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        configureTableView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        viewModel?.didFinish()
    }
    
    // MARK: UIStatusBarStyle
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    // MARK: Scrollbar
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let visibleCells = tableView.visibleCells as? [WeatherListCell] else { return }
        
        for cell in visibleCells {
            
            guard let clipBottomConstraint = cell.clipView.constraints.filter({ $0.firstAttribute == .bottom }).first,
                  let clipHeightConstraint = cell.clipView.constraints.filter({ $0.firstAttribute == .height }).first
            else { return }
            
            let defaultClipHeight = cell.heightForClipView
            let bottomSpace = clipBottomConstraint.constant < 0 ? -clipBottomConstraint.constant : clipBottomConstraint.constant
            let topSpace = cell.frame.height - defaultClipHeight - bottomSpace
            let cellOffsetY = tableView.contentOffset.y - cell.frame.origin.y + UIApplication.statusBarHeight + 7
            
            if cellOffsetY > topSpace {
                let clipOffsetY = cellOffsetY - topSpace
                let clipHeight = defaultClipHeight - clipOffsetY
                
                clipHeightConstraint.constant = max(clipHeight, 0)
            } else {
                clipHeightConstraint.constant = defaultClipHeight
            }
        }
    }
}

// MARK: Private Methods
extension WeatherListViewController {
    private func configureUI() {
        view.backgroundColor = .brown
    }
    
    private func configureTableView() {
        tableView.register(WeatherListCell.self, forCellReuseIdentifier: WeatherListCell.reuseIdentifier)
        tableView.register(WeatherListFooterView.self, forHeaderFooterViewReuseIdentifier: WeatherListFooterView.reuseIdentifier)
        
        tableView.backgroundColor = .black
        tableView.insetsContentViewsToSafeArea = false
        tableView.contentInsetAdjustmentBehavior = .never
    }
}

// MARK: WeatherListFooterViewDelegate
extension WeatherListViewController: WeatherListFooterViewDelegate {
    func goToSearch() {
        viewModel?.goToSearch(from: self)
    }
}

// MARK: UITableViewDataSource
extension WeatherListViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        weatherModels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
                withIdentifier: WeatherListCell.reuseIdentifier,
                for: indexPath
        ) as? WeatherListCell else { return UITableViewCell() }
        
        cell.viewModel = viewModel?.cellViewModel(at: indexPath)
        cell.selectionStyle = .none

        return cell
    }
    
}

// MARK: UITableViewDelegate
extension WeatherListViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        indexPath.row == 0 ? Constant.heightForRowWeatherList + UIApplication.statusBarHeight : Constant.heightForRowWeatherList
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard weatherModels.count > 0 else { return nil }
        
        let deleteAction = UIContextualAction(
            style: .destructive,
            title: "Delete"
        ) { [weak self] (_, _, completion) in
            self?.weatherModels.remove(at: indexPath.row)
            self?.tableView.deleteRows(at: [indexPath], with: .right)
            self?.viewModel?.removeWeatherModel(at: indexPath.row)
            
            completion(true)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel?.goToSelectedWeatherPage(at: indexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footer = tableView.dequeueReusableHeaderFooterView(
                withIdentifier: WeatherListFooterView.reuseIdentifier
        ) as? WeatherListFooterView else { return nil }
        
        let footerViewModel = WeatherListFooterViewModel()
        footerViewModel.delegate = self
        
        footer.viewModel = footerViewModel
        
        return footer
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        weatherModels.isEmpty ? Constant.heightForFooterWeatherList + UIApplication.statusBarHeight : Constant.heightForFooterWeatherList
    }
}
