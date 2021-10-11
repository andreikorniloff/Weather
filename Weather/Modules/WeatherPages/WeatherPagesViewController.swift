//
//  WeatherPagesViewController.swift
//  Weather
//
//  Created by Andrei Kornilov on 04.10.2021.
//

import UIKit

final class WeatherPagesViewController: UIPageViewController {
    // MARK: Private Properties
    private let disposeBag = DisposeBag()
    private var pages: [WeatherPageViewController] = []
    
    // MARK: View Model
    var viewModel: WeatherPagesViewModelType? {
        didSet {
            bindPageViewModels()
        }
    }

    // MARK: UI Components
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.addTarget(self, action: #selector(pageControlTapped(sender:)), for: .touchUpInside)
        
        return pageControl
    }()
    
    private lazy var githubBarButtonItem: UIBarButtonItem = {
        let item = UIBarButtonItem(
            image: UIImage(named: "githubIcon"),
            style: .plain,
            target: self,
            action: #selector(githubBarButtonItemTapped)
        )
        item.tintColor = .white
        return item
    }()
    
    private lazy var listBarButtonItem: UIBarButtonItem = {
        let item = UIBarButtonItem(
            image: UIImage(systemName: "list.dash"),
            style: .plain,
            target: self,
            action: #selector(listBarButtonItemTapped)
        )
        item.tintColor = .white
        return item
    }()
    
    // MARK: Initialization
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: UIStatusBarStyle
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        configureUI()
    }
}

// MARK: Data Binding
extension WeatherPagesViewController {
    private func bindPageViewModels() {
        guard let pageViewModels = viewModel?.pageViewModels else { return }
        
        pageViewModels
            .bind { [weak self] _ in
                DispatchQueue.main.async {
                    self?.configurePages()
                    self?.configurePageControl()
                }
            }
            .disposed(by: disposeBag)
    }
}

// MARK: Private Methods
extension WeatherPagesViewController {
    private func configure() {
        dataSource = self
        delegate = self
    }

    private func configureUI() {
        view.backgroundColor = Color.defaultBackgound

        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 0.5)
        topBorder.backgroundColor = Color.weatherWhite.cgColor

        navigationController?.toolbar.layer.addSublayer(topBorder)
    }
    
    private func configurePages() {
        guard let pageViewModels = viewModel?.pageViewModels.value,
              pageViewModels.count > 0 else { return }
        
        pages = pageViewModels.map {
            let pageViewController = WeatherPageViewController()
            pageViewController.viewModel = $0
            
            return pageViewController
        }
    }
    
    private func configurePageControl() {
        var currentPage: WeatherPageViewController?
        
        pageControl.numberOfPages = pages.count
        if pageControl.currentPage > 0, pages.count > pageControl.currentPage {
            currentPage = pages[pageControl.currentPage]
        } else {
            currentPage = pages.first
        }
        
        if let currentPage = currentPage {
            setViewControllers([currentPage], direction: .forward, animated: false, completion: nil)
        }
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let pageControlItem = UIBarButtonItem(customView: pageControl)
        pageControlItem.tintColor = .white
        
        toolbarItems = [
            githubBarButtonItem,
            flexibleSpace,
            pageControlItem,
            flexibleSpace,
            listBarButtonItem
        ]
    }
}

// MARK: Button Actions
extension WeatherPagesViewController {
    @objc
    private func pageControlTapped(sender: UIPageControl) {
        setViewControllers([pages[sender.currentPage]], direction: .forward, animated: true, completion: nil)
    }
    
    @objc
    private func githubBarButtonItemTapped() {
        if let url = URL(string: Constant.githubURL) {
            UIApplication.shared.open(url)
        }
    }
    
    @objc
    private func listBarButtonItemTapped() {
        viewModel?.goToWeatherList(delegate: self)
    }
}

// MARK: WeatherListDelegate
extension WeatherPagesViewController: WeatherListDelegate {
    func didSelectWeatherPage(at index: Int) {
        if index > 0 {
            setViewControllers([pages[index - 1]], direction: .reverse, animated: true, completion: nil)
            setViewControllers([pages[index]], direction: .forward, animated: true, completion: nil)
        } else {
            if pages.count > 1 {
                setViewControllers([pages[index + 1]], direction: .forward, animated: true, completion: nil)
            }
            setViewControllers([pages[index]], direction: .reverse, animated: true, completion: nil)
        }
        
        pageControl.currentPage = index
    }
}

// MARK: UIPageViewControllerDataSource
extension WeatherPagesViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? WeatherPageViewController,
              let currentIndex = pages.firstIndex(of: viewController)
        else { return nil }

        if currentIndex == 0 {
            return nil
        } else {
            return pages[currentIndex - 1]
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? WeatherPageViewController,
              let currentIndex = pages.firstIndex(of: viewController)
        else { return nil }

        if currentIndex < pages.count - 1 {
            return pages[currentIndex + 1]
        } else {
            return nil
        }
    }
}

// MARK: UIPageViewControllerDelegate
extension WeatherPagesViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let viewControllers = pageViewController.viewControllers,
              let viewController = viewControllers.first as? WeatherPageViewController,
              let currentIndex = pages.firstIndex(of: viewController) else { return }

        pageControl.currentPage = currentIndex
    }
}


