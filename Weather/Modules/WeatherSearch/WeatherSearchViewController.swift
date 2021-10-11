//
//  WeatherSearchViewController.swift
//  Weather
//
//  Created by Andrei Kornilov on 04.10.2021.
//

import UIKit

final class WeatherSearchViewController: UIViewController {
    // MARK: View Model
    var viewModel: WeatherSearchViewModelType?
    
    // MARK: Private Properties
    private let cellReuseIdentifier = "WeatherSearchCell"
    private var locations = [Location]()
    
    // MARK: UI Components
    lazy private var errorLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "No results found."
        label.textColor = .white.withAlphaComponent(0.8)
        label.isHidden = true
        
        return label
    }()
    
    lazy private var tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        return tableView
    }()
    
    lazy private var stackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        
        stackView.addArrangedSubview(errorLabel)
        stackView.addArrangedSubview(tableView)
        
        return stackView
    }()
    
    lazy private var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.automaticallyShowsCancelButton = true
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.becomeFirstResponder()
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.showsCancelButton = true
        searchController.searchBar.tintColor = .white
        searchController.searchBar.searchTextField.textColor = .white
        
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        
        return searchController
    }()

    // MARK: Lyfe Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
        configureNavigationItems()
        configureUI()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        viewModel?.didFinish()
    }
}

// MARK: Private Methods
extension WeatherSearchViewController {
    private func configureTableView() {
        
    }
    
    private func configureNavigationItems() {
        navigationItem.titleView = searchController.searchBar
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.prompt = "Enter city, postcode or airport location"

        definesPresentationContext = true
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = Color.defaultBackgound
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.barStyle = .black
    }
    
    private func configureUI() {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.frame
        view.addSubview(blurEffectView)
        
        view.addSubview(stackView)
        stackView.edgeTo(layoutGuide: view.safeAreaLayoutGuide)
        
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.leftAnchor.constraint(equalTo: stackView.leftAnchor, constant: 16).isActive = true
        errorLabel.rightAnchor.constraint(equalTo: stackView.rightAnchor).isActive = true
    }
}

// MARK: UISearchResultsUpdating
extension WeatherSearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text, !text.isEmpty {
            LocationManager.shared.findLocations(with: text) { [weak self] locations in
                DispatchQueue.main.async {
                    self?.locations = locations
                    self?.tableView.reloadData()
                    
                    guard let locationsCount = self?.locations.count else { return }
                    
                    self?.errorLabel.isHidden = locationsCount > 0
                }
            }
        }
    }
}

// MARK: UISearchBarDelegate
extension WeatherSearchViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dismiss(animated: true)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            DispatchQueue.main.async { [weak self] in
                self?.errorLabel.isHidden = true
                self?.locations = []
                self?.tableView.reloadData()
            }
        }
    }
}

// MARK: UITableViewDelegate, UITableViewDataSource
extension WeatherSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        
        cell.textLabel?.text = locations[indexPath.row].title
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.textColor = .white
        cell.backgroundColor = .clear
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let location = locations[indexPath.row]
        
        viewModel?.goToWeatherAdding(with: location)
    }
}
